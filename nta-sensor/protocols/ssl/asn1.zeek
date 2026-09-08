
type ReadBytesResult:record {
    content:    string  &log    &default="";
    result:     string  &log    &default="";
    success:    bool    &log    &default=F;
};

type ASN1Object:record {
    data_type:          count       &log &default=0;
    length:             count       &log &default=0;
    value:              string      &log &default="";
    rest:               string      &log &default="";
};

type PublicKeyResult: record {
    raw:                string &log &default="";
    pk:                 string &log &default="";
    exponent:           count &log &default=0;
};

function hexstr_to_count(s: string): count {
    if (|s| % 2 != 0) {
       s = "\x00" + s;
    }
    return bytestring_to_count(s);
}

function read_n_bytes(content:string, n:count): ReadBytesResult {
    if (|content| < n) {
        return ReadBytesResult(
            $content = "",
            $result = "",
            $success = F
        );
    }
    return ReadBytesResult(
        $content = content[n:],
        $result = content[:n],
        $success = T
    );
}

function read_part(content:string): ASN1Object {
    local result = ReadBytesResult();
    
    result = read_n_bytes(content, 1);
    if (!result$success) {
        print("Failed to read part, due to can not read data type");
        return ASN1Object();
    }
    content = result$content;
    local object_type = hexstr_to_count(result$result);
    if (object_type == 0) {
        return ASN1Object(
            $data_type=object_type,
            $length=0,
            $value="",
            $rest=content
        );
    }

    result = read_n_bytes(content, 1);
    if (!result$success) {
        print("Failed to read part, due to can not read length");
        return ASN1Object();
    }
    content = result$content;
    local object_length = hexstr_to_count(result$result);
    if (object_length & 0x80 > 0) {
        object_length = object_length & 0x7f;

        result = read_n_bytes(content, object_length);
        if (!result$success) {
            print("Failed to read part, due to can not read length");
            return ASN1Object();
        }
        content = result$content;
        object_length = hexstr_to_count(result$result);
    }

    result = read_n_bytes(content, object_length);
    if (!result$success) {
        print("Failed to read part, due to can not read content");
        return ASN1Object();
    }
    local object_value = result$result;
    content = result$content;

    return ASN1Object(
        $data_type=object_type,
        $length=object_length,
        $value=object_value,
        $rest=content
    );
}



export {
    function parse_public_key(cert: string): PublicKeyResult {
        local restCert = cert;
        if (|cert| < 1) {
            return PublicKeyResult();
        }

        local length = 0;
        local result = ReadBytesResult();
        local bs = "";

        local outer = read_part(cert);
        local certificate = read_part(outer$value);
        local version = read_part(certificate$value);
        local serial_number = read_part(version$rest);
        local signature_algorithm = read_part(serial_number$rest);
        local cert_issuer = read_part(signature_algorithm$rest);
        local validity = read_part(cert_issuer$rest);
        local cert_subject = read_part(validity$rest);
        local subject_public_key_info = read_part(cert_subject$rest);
        local algorithm = read_part(subject_public_key_info$value);
        local subject_public_key =  read_part(algorithm$rest);
        local ignore = read_part(subject_public_key$value);
        local pkObject = read_part(ignore$rest);
        local pk = read_part(pkObject$value);
        local exponent = read_part(pk$rest);
      
        local res = PublicKeyResult(
            $pk=pk$value[1:],
            $exponent=hexstr_to_count(exponent$value)
        );
        
        return res;
    }
}



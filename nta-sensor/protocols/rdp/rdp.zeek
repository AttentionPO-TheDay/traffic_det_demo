##! RDP Connection Information Extractor
##! This script extracts basic RDP connection information and stores it in the connection record

@load base/protocols/conn
@load base/protocols/rdp
@load ../type

module RDP;

function init_rdp_meta(c: connection) {
    Protocols::init_protocol_meta(c);
    if ( ! c$meta?$rdp )
        c$meta$rdp = RDP::Meta();
}

event rdp_client_core_data(c: connection, data: RDP::ClientCoreData) {
    init_rdp_meta(c);
    
    local rdp_mata = c$meta$rdp;
    
    # Extract version information
    rdp_mata$version = fmt("RDP %d.%d", data$version_major, data$version_minor);
    
    rdp_mata$desktop_width = data$desktop_width;
    rdp_mata$desktop_height = data$desktop_height;
    rdp_mata$color_depth = data$color_depth;
    rdp_mata$keyboard_layout = data$keyboard_layout;
    rdp_mata$client_name = data$client_name;
}

# Extract security information
event rdp_client_security_data(c: connection, data: RDP::ClientSecurityData) {
    init_rdp_meta(c);
    
    local rdp_meta = c$meta$rdp;

    # Determine security protocol
    if ( data?$encryption_methods ) {
        rdp_meta$security_methods = vector();
        if ( (data$encryption_methods & 0x01) != 0 )
            rdp_meta$security_methods += "40-bit RC4";
        if ( (data$encryption_methods & 0x02) != 0 )
            rdp_meta$security_methods += "128-bit RC4";
        if ( (data$encryption_methods & 0x08) != 0 )
            rdp_meta$security_methods += "56-bit RC4";
        if ( (data$encryption_methods & 0x10) != 0 )
            rdp_meta$security_methods += "FIPS 140-1";
    }
}

# Capture connection results
event rdp_server_certificate (c: connection, cert_type: count, permanently_issued: bool) {
    init_rdp_meta(c);
    
    # If we get a certificate, the initial handshake was successful
    c$meta$rdp$result = "handshake_success";
}

# Handle connection failures
event rdp_negotiation_failure(c: connection, failure_code: count) {
    init_rdp_meta(c);
    
    local rdp_meta = c$meta$rdp;

    rdp_meta$result = "negotiation_failure";
    rdp_meta$error_code = failure_code;
}

# Calculate session duration when connection ends
event connection_state_remove(c: connection) {
    if ( c$meta?$rdp && c?$start_time ) {
        c$meta$rdp$session_duration = network_time() - c$start_time;
    }
}

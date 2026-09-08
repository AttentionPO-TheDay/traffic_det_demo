module SMTP;

export {
    type Meta: record {
        helo:              string           &log      &default="";
        mailfrom:          string           &log      &default="";
        rcptto:            set[string]      &log      &optional;
        date:              string           &log      &default="";
        user_agent:        string           &log      &default="";
        subject:           string           &log      &optional;
        charset:           string           &log      &optional;
        subject_base64:    string           &log      &optional;
        data:              string           &log      &default="";
        auth_type:              string           &log      &default="";
        auth_content:              string           &log      &default="";
    };
}
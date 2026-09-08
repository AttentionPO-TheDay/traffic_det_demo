module RDP;

export {
    type Meta: record {
        ## RDP protocol version
        version: string &log &optional;
        ## Client name/hostname
        client_name: string &log &optional;
        ## RDP security protocol used
        security_methods: vector of string &log &optional;
        ## Screen resolution requested
        desktop_width: count &log &optional;
        desktop_height: count &log &optional;
        ## Color depth
        color_depth: count &log &optional;
        ## Keyboard layout
        keyboard_layout: count &log &optional;
        ## Connection result (success/failure)
        result: string &log &optional;
        ## Error code if connection failed
        error_code: count &log &optional;
        ## Session duration
        session_duration: interval &log &optional;
    };
}
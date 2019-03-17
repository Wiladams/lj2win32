local enum = require("enum")

local pages = enum {
HID_USAGE_PAGE_UNDEFINED                        = 0x00;
HID_USAGE_PAGE_GENERIC                          = 0x01;
HID_USAGE_PAGE_SIMULATION                       = 0x02;
HID_USAGE_PAGE_VR                               = 0x03;
HID_USAGE_PAGE_SPORT                            = 0x04;
HID_USAGE_PAGE_GAME                             = 0x05;
HID_USAGE_PAGE_GENERIC_DEVICE                   = 0x06;
HID_USAGE_PAGE_KEYBOARD                         = 0x07;
HID_USAGE_PAGE_LED                              = 0x08;
HID_USAGE_PAGE_BUTTON                           = 0x09;
HID_USAGE_PAGE_ORDINAL                          = 0x0A;
HID_USAGE_PAGE_TELEPHONY                        = 0x0B;
HID_USAGE_PAGE_CONSUMER                         = 0x0C;
HID_USAGE_PAGE_DIGITIZER                        = 0x0D;
HID_USAGE_PAGE_HAPTICS                          = 0x0E;
HID_USAGE_PAGE_PID                              = 0x0F;
HID_USAGE_PAGE_UNICODE                          = 0x10;
HID_USAGE_PAGE_ALPHANUMERIC                     = 0x14;
HID_USAGE_PAGE_SENSOR                           = 0x20;
HID_USAGE_PAGE_BARCODE_SCANNER                  = 0x8C;
HID_USAGE_PAGE_WEIGHING_DEVICE                  = 0x8D;
HID_USAGE_PAGE_MAGNETIC_STRIPE_READER           = 0x8E;
HID_USAGE_PAGE_CAMERA_CONTROL                   = 0x90;
HID_USAGE_PAGE_ARCADE                           = 0x91;
HID_USAGE_PAGE_MICROSOFT_BLUETOOTH_HANDSFREE    = 0xFFF3;
HID_USAGE_PAGE_VENDOR_DEFINED_BEGIN             = 0xFF00;
HID_USAGE_PAGE_VENDOR_DEFINED_END               = 0xFFFF;
}

local usages = {
    [pages.HID_USAGE_PAGE_GENERIC] = enum {
        HID_USAGE_GENERIC_POINTER                                       = 0x01;
        HID_USAGE_GENERIC_MOUSE                                         = 0x02;
        HID_USAGE_GENERIC_JOYSTICK                                      = 0x04;
        HID_USAGE_GENERIC_GAMEPAD                                       = 0x05;
        HID_USAGE_GENERIC_KEYBOARD                                      = 0x06;
        HID_USAGE_GENERIC_KEYPAD                                        = 0x07;
        HID_USAGE_GENERIC_MULTI_AXIS_CONTROLLER                         = 0x08;
        HID_USAGE_GENERIC_TABLET_PC_SYSTEM_CTL                          = 0x09;
        HID_USAGE_GENERIC_PORTABLE_DEVICE_CONTROL                       = 0x0D;
        HID_USAGE_GENERIC_INTERACTIVE_CONTROL                           = 0x0E;
        HID_USAGE_GENERIC_SYSTEM_CTL                                    = 0x80;
    };

    [pages.HID_USAGE_PAGE_DIGITIZER] = enum {
        HID_USAGE_DIGITIZER_DIGITIZER               = 0x01;
        HID_USAGE_DIGITIZER_PEN                     = 0x02;
        HID_USAGE_DIGITIZER_LIGHT_PEN               = 0x03;
        HID_USAGE_DIGITIZER_TOUCH_SCREEN            = 0x04;
        HID_USAGE_DIGITIZER_TOUCH_PAD               = 0x05;
        HID_USAGE_DIGITIZER_WHITE_BOARD             = 0x06;
        HID_USAGE_DIGITIZER_COORD_MEASURING         = 0x07;
        HID_USAGE_DIGITIZER_3D_DIGITIZER            = 0x08;
        HID_USAGE_DIGITIZER_STEREO_PLOTTER          = 0x09;
        HID_USAGE_DIGITIZER_ARTICULATED_ARM         = 0x0A;
        HID_USAGE_DIGITIZER_ARMATURE                = 0x0B;
        HID_USAGE_DIGITIZER_MULTI_POINT             = 0x0C;
        HID_USAGE_DIGITIZER_FREE_SPACE_WAND         = 0x0D;
        HID_USAGE_DIGITIZER_STYLUS                  = 0x20;
        HID_USAGE_DIGITIZER_PUCK                    = 0x21;
        HID_USAGE_DIGITIZER_FINGER                  = 0x22;
        HID_USAGE_DIGITIZER_TABLET_FUNC_KEYS        = 0x39;
        HID_USAGE_DIGITIZER_PROG_CHANGE_KEYS        = 0x3A;

        HID_USAGE_DIGITIZER_TIP_PRESSURE            = 0x30;
        HID_USAGE_DIGITIZER_BARREL_PRESSURE         = 0x31;
        HID_USAGE_DIGITIZER_IN_RANGE                = 0x32;
        HID_USAGE_DIGITIZER_TOUCH                   = 0x33;
        HID_USAGE_DIGITIZER_UNTOUCH                 = 0x34;
        HID_USAGE_DIGITIZER_TAP                     = 0x35;
        HID_USAGE_DIGITIZER_QUALITY                 = 0x36;
        HID_USAGE_DIGITIZER_DATA_VALID              = 0x37;
        HID_USAGE_DIGITIZER_TRANSDUCER_INDEX        = 0x38;
        HID_USAGE_DIGITIZER_BATTERY_STRENGTH        = 0x3B;
        HID_USAGE_DIGITIZER_INVERT                  = 0x3C;
        HID_USAGE_DIGITIZER_X_TILT                  = 0x3D;
        HID_USAGE_DIGITIZER_Y_TILT                  = 0x3E;
        HID_USAGE_DIGITIZER_AZIMUTH                 = 0x3F;
        HID_USAGE_DIGITIZER_ALTITUDE                = 0x40;
        HID_USAGE_DIGITIZER_TWIST                   = 0x41;
        HID_USAGE_DIGITIZER_TIP_SWITCH              = 0x42;
        HID_USAGE_DIGITIZER_SECONDARY_TIP_SWITCH    = 0x43;
        HID_USAGE_DIGITIZER_BARREL_SWITCH           = 0x44;
        HID_USAGE_DIGITIZER_ERASER                  = 0x45;
        HID_USAGE_DIGITIZER_TABLET_PICK             = 0x46;
    }
}
return {
    pages = pages;
    usage = usages;
}
local enum = require("enum")

local hidusagedb = {
    [0x00] = {
        name = "UNDEFINED",
        usage = enum {

        }
    },

    [0x01] = {
        name = "GENERIC",
        usage = enum {
            POINTER                                       = 0x01;
            MOUSE                                         = 0x02;
            JOYSTICK                                      = 0x04;
            GAMEPAD                                       = 0x05;
            KEYBOARD                                      = 0x06;
            KEYPAD                                        = 0x07;
            MULTI_AXIS_CONTROLLER                         = 0x08;
            TABLET_PC_SYSTEM_CTL                          = 0x09;
            PORTABLE_DEVICE_CONTROL                       = 0x0D;
            INTERACTIVE_CONTROL                           = 0x0E;
            SYSTEM_CTL                                    = 0x80;

            X                                             = 0x30;
            Y                                             = 0x31;
            Z                                             = 0x32;
            RX                                            = 0x33;
            RY                                            = 0x34;
            RZ                                            = 0x35;
            SLIDER                                        = 0x36;
            DIAL                                          = 0x37;
            WHEEL                                         = 0x38;
            HATSWITCH                                     = 0x39;
            COUNTED_BUFFER                                = 0x3A;
            BYTE_COUNT                                    = 0x3B;
            MOTION_WAKEUP                                 = 0x3C;
            START                                         = 0x3D;
            SELECT                                        = 0x3E;
            VX                                            = 0x40;
            VY                                            = 0x41;
            VZ                                            = 0x42;
            VBRX                                          = 0x43;
            VBRY                                          = 0x44;
            VBRZ                                          = 0x45;
            VNO                                           = 0x46;
            FEATURE_NOTIFICATION                          = 0x47;
            RESOLUTION_MULTIPLIER                         = 0x48;
            
            -- System Control
            SYSCTL_POWER                                  = 0x81;
            SYSCTL_SLEEP                                  = 0x82;
            SYSCTL_WAKE                                   = 0x83;
            SYSCTL_CONTEXT_MENU                           = 0x84;
            SYSCTL_MAIN_MENU                              = 0x85;
            SYSCTL_APP_MENU                               = 0x86;
            SYSCTL_HELP_MENU                              = 0x87;
            SYSCTL_MENU_EXIT                              = 0x88;
            SYSCTL_MENU_SELECT                            = 0x89;
            SYSCTL_MENU_RIGHT                             = 0x8A;
            SYSCTL_MENU_LEFT                              = 0x8B;
            SYSCTL_MENU_UP                                = 0x8C;
            SYSCTL_MENU_DOWN                              = 0x8D;
            SYSCTL_COLD_RESTART                           = 0x8E;
            SYSCTL_WARM_RESTART                           = 0x8F;

            -- simple game pad
            DPAD_UP                                       = 0x90;
            DPAD_DOWN                                     = 0x91;
            DPAD_RIGHT                                    = 0x92;
            DPAD_LEFT                                     = 0x93;

            SYSCTL_DISMISS_NOTIFICATION                   = 0x9A;
            SYSCTL_DOCK                                   = 0xA0;
            SYSCTL_UNDOCK                                 = 0xA1;
            SYSCTL_SETUP                                  = 0xA2;
            SYSCTL_SYS_BREAK                              = 0xA3;
            SYSCTL_SYS_DBG_BREAK                          = 0xA4;
            SYSCTL_APP_BREAK                              = 0xA5;
            SYSCTL_APP_DBG_BREAK                          = 0xA6;
            SYSCTL_MUTE                                   = 0xA7;
            SYSCTL_HIBERNATE                              = 0xA8;
            SYSCTL_DISP_INVERT                            = 0xB0;
            SYSCTL_DISP_INTERNAL                          = 0xB1;
            SYSCTL_DISP_EXTERNAL                          = 0xB2;
            SYSCTL_DISP_BOTH                              = 0xB3;
            SYSCTL_DISP_DUAL                              = 0xB4;
            SYSCTL_DISP_TOGGLE                            = 0xB5;
            SYSCTL_DISP_SWAP                              = 0xB6;
            SYSCTL_DISP_AUTOSCALE                         = 0xB7;
            SYSTEM_DISPLAY_ROTATION_LOCK_BUTTON           = 0xC9;
            SYSTEM_DISPLAY_ROTATION_LOCK_SLIDER_SWITCH    = 0xCA;
            CONTROL_ENABLE                                = 0xCB;
        }
    },

    [0x02] = {
        name = "SIMULATION",
        usage = enum {
            FLIGHT_SIMULATION_DEVICE          = 0x01;
            AUTOMOBILE_SIMULATION_DEVICE      = 0x02;
            TANK_SIMULATION_DEVICE            = 0x03;
            SPACESHIP_SIMULATION_DEVICE       = 0x04;
            SUBMARINE_SIMULATION_DEVICE       = 0x05;
            SAILING_SIMULATION_DEVICE         = 0x06;
            MOTORCYCLE_SIMULATION_DEVICE      = 0x07;
            SPORTS_SIMULATION_DEVICE          = 0x08;
            AIRPLANE_SIMULATION_DEVICE        = 0x09;
            HELICOPTER_SIMULATION_DEVICE      = 0x0A;
            MAGIC_CARPET_SIMULATION_DEVICE    = 0x0B;
            BICYCLE_SIMULATION_DEVICE         = 0x0C;
            FLIGHT_CONTROL_STICK              = 0x20;
            FLIGHT_STICK                      = 0x21;
            CYCLIC_CONTROL                    = 0x22;
            CYCLIC_TRIM                       = 0x23;
            FLIGHT_YOKE                       = 0x24;
            TRACK_CONTROL                     = 0x25;

            AILERON                           = 0xB0;
            AILERON_TRIM                      = 0xB1;
            ANTI_TORQUE_CONTROL               = 0xB2;
            AUTOPIOLOT_ENABLE                 = 0xB3;
            CHAFF_RELEASE                     = 0xB4;
            COLLECTIVE_CONTROL                = 0xB5;
            DIVE_BRAKE                        = 0xB6;
            ELECTRONIC_COUNTERMEASURES        = 0xB7;
            ELEVATOR                          = 0xB8;
            ELEVATOR_TRIM                     = 0xB9;
            RUDDER                            = 0xBA;
            THROTTLE                          = 0xBB;
            FLIGHT_COMMUNICATIONS             = 0xBC;
            FLARE_RELEASE                     = 0xBD;
            LANDING_GEAR                      = 0xBE;
            TOE_BRAKE                         = 0xBF;
            TRIGGER                           = 0xC0;
            WEAPONS_ARM                       = 0xC1;
            WEAPONS_SELECT                    = 0xC2;
            WING_FLAPS                        = 0xC3;
            ACCELLERATOR                      = 0xC4;
            BRAKE                             = 0xC5;
            CLUTCH                            = 0xC6;
            SHIFTER                           = 0xC7;
            STEERING                          = 0xC8;
            TURRET_DIRECTION                  = 0xC9;
            BARREL_ELEVATION                  = 0xCA;
            DIVE_PLANE                        = 0xCB;
            BALLAST                           = 0xCC;
            BICYCLE_CRANK                     = 0xCD;
            HANDLE_BARS                       = 0xCE;
            FRONT_BRAKE                       = 0xCF;
            REAR_BRAKE                        = 0xD0;
            
        },
    },

    [0x03] = {
        name = "VR",
        usage = enum {
            BELT                    = 0x01;
            BODY_SUIT               = 0x02;
            FLEXOR                  = 0x03;
            GLOVE                   = 0x04;
            HEAD_TRACKER            = 0x05;
            HEAD_MOUNTED_DISPLAY    = 0x06;
            HAND_TRACKER            = 0x07;
            OCULOMETER              = 0x08;
            VEST                    = 0x09;
            ANIMATRONIC_DEVICE      = 0x0A;
            
            STEREO_ENABLE           = 0x20;
            DISPLAY_ENABLE          = 0x21;
            
        },
    },

    [0x04] = {
        name = "SPORT",
        usage = enum {
            BASEBALL_BAT        = 0x01;
            GOLF_CLUB           = 0x02;
            ROWING_MACHINE      = 0x03;
            TREADMILL           = 0x04;
            STICK_TYPE          = 0x38;
            
            OAR                 = 0x30;
            SLOPE               = 0x31;
            RATE                = 0x32;
            STICK_SPEED         = 0x33;
            STICK_FACE_ANGLE    = 0x34;
            HEEL_TOE            = 0x35;
            FOLLOW_THROUGH      = 0x36;
            TEMPO               = 0x37;
            HEIGHT              = 0x39;
            PUTTER              = 0x50;
            ["1_IRON"]              = 0x51;
            ["2_IRON"]              = 0x52;
            ["3_IRON"]              = 0x53;
            ["4_IRON"]              = 0x54;
            ["5_IRON"]              = 0x55;
            ["6_IRON"]              = 0x56;
            ["7_IRON"]              = 0x57;
            ["8_IRON"]              = 0x58;
            ["9_IRON"]              = 0x59;
            ["10_IRON"]             = 0x5A;
            ["11_IRON"]             = 0x5B;
            SAND_WEDGE          = 0x5C;
            LOFT_WEDGE          = 0x5D;
            POWER_WEDGE         = 0x5E;
            ["1_WOOD"]              = 0x5F;
            ["3_WOOD"]              = 0x60;
            ["5_WOOD"]              = 0x61;
            ["7_WOOD"]              = 0x62;
            ["9_WOOD"]              = 0x63;
            
        },
    },

    [0x05] = {
        name = "GAME",
        usage = enum {
            ["3D_GAME_CONTROLLER"]    = 0x01;
            PINBALL_DEVICE        = 0x02;
            GUN_DEVICE            = 0x03;
            POINT_OF_VIEW         = 0x20;
            GUN_SELECTOR          = 0x32;
            GAMEPAD_FIRE_JUMP     = 0x37;
            GAMEPAD_TRIGGER       = 0x39;
            
            TURN_RIGHT_LEFT       = 0x21;
            PITCH_FORWARD_BACK    = 0x22;
            ROLL_RIGHT_LEFT       = 0x23;
            MOVE_RIGHT_LEFT       = 0x24;
            MOVE_FORWARD_BACK     = 0x25;
            MOVE_UP_DOWN          = 0x26;
            LEAN_RIGHT_LEFT       = 0x27;
            LEAN_FORWARD_BACK     = 0x28;
            POV_HEIGHT            = 0x29;
            FLIPPER               = 0x2A;
            SECONDARY_FLIPPER     = 0x2B;
            BUMP                  = 0x2C;
            NEW_GAME              = 0x2D;
            SHOOT_BALL            = 0x2E;
            PLAYER                = 0x2F;
            GUN_BOLT              = 0x30;
            GUN_CLIP              = 0x31;
            GUN_SINGLE_SHOT       = 0x33;
            GUN_BURST             = 0x34;
            GUN_AUTOMATIC         = 0x35;
            GUN_SAFETY            = 0x36;
            
        },
    },

    [0x06] = {
        name = "DEVICE",
        usage = enum {
            BATTERY_STRENGTH              = 0x20;
            WIRELESS_CHANNEL              = 0x21;
            WIRELESS_ID                   = 0x22;
            DISCOVER_WIRELESS_CONTROL     = 0x23;
            SECURITY_CODE_CHAR_ENTERED    = 0x24;
            SECURITY_CODE_CHAR_ERASED     = 0x25;
            SECURITY_CODE_CLEARED         = 0x26;
            
        },
    },

    [0x07] = {
        name = "KEYBOARD",
        usage = enum {
            NOEVENT     = 0x00;
            ROLLOVER    = 0x01;
            POSTFAIL    = 0x02;
            UNDEFINED   = 0x03;
            
            -- Letters
            aA          = 0x04;
            zZ          = 0x1D;
            
            -- Numbers
            ONE         = 0x1E;
            ZERO        = 0x27;
            
            -- Modifier Keys
            LCTRL       = 0xE0;
            LSHFT       = 0xE1;
            LALT        = 0xE2;
            LGUI        = 0xE3;
            RCTRL       = 0xE4;
            RSHFT       = 0xE5;
            RALT        = 0xE6;
            RGUI        = 0xE7;
            SCROLL_LOCK = 0x47;
            NUM_LOCK    = 0x53;
            CAPS_LOCK   = 0x39;
            
            -- Function keys
            F1          = 0x3A;
            F2          = 0x3B;
            F3          = 0x3C;
            F4          = 0x3D;
            F5          = 0x3E;
            F6          = 0x3F;
            F7          = 0x40;
            F8          = 0x41;
            F9          = 0x42;
            F10         = 0x43;
            F11         = 0x44;
            F12         = 0x45;
            F13         = 0x68;
            F14         = 0x69;
            F15         = 0x6A;
            F16         = 0x6B;
            F17         = 0x6C;
            F18         = 0x6D;
            F19         = 0x6E;
            F20         = 0x6F;
            F21         = 0x70;
            F22         = 0x71;
            F23         = 0x72;
            F24         = 0x73;
            
            RETURN      = 0x28;
            ESCAPE      = 0x29;
            DELETE      = 0x2A;
            
            PRINT_SCREEN      = 0x46;
            DELETE_FORWARD    = 0x4C;
        },
    },

    [0x08] = {
        name = "LED",
        usage = enum {
            NUM_LOCK               = 0x01;
            CAPS_LOCK              = 0x02;
            SCROLL_LOCK            = 0x03;
            COMPOSE                = 0x04;
            KANA                   = 0x05;
            POWER                  = 0x06;
            SHIFT                  = 0x07;
            DO_NOT_DISTURB         = 0x08;
            MUTE                   = 0x09;
            TONE_ENABLE            = 0x0A;
            HIGH_CUT_FILTER        = 0x0B;
            LOW_CUT_FILTER         = 0x0C;
            EQUALIZER_ENABLE       = 0x0D;
            SOUND_FIELD_ON         = 0x0E;
            SURROUND_FIELD_ON      = 0x0F;
            REPEAT                 = 0x10;
            STEREO                 = 0x11;
            SAMPLING_RATE_DETECT   = 0x12;
            SPINNING               = 0x13;
            CAV                    = 0x14;
            CLV                    = 0x15;
            RECORDING_FORMAT_DET   = 0x16;
            OFF_HOOK               = 0x17;
            RING                   = 0x18;
            MESSAGE_WAITING        = 0x19;
            DATA_MODE              = 0x1A;
            BATTERY_OPERATION      = 0x1B;
            BATTERY_OK             = 0x1C;
            BATTERY_LOW            = 0x1D;
            SPEAKER                = 0x1E;
            HEAD_SET               = 0x1F;
            HOLD                   = 0x20;
            MICROPHONE             = 0x21;
            COVERAGE               = 0x22;
            NIGHT_MODE             = 0x23;
            SEND_CALLS             = 0x24;
            CALL_PICKUP            = 0x25;
            CONFERENCE             = 0x26;
            STAND_BY               = 0x27;
            CAMERA_ON              = 0x28;
            CAMERA_OFF             = 0x29;
            ON_LINE                = 0x2A;
            OFF_LINE               = 0x2B;
            BUSY                   = 0x2C;
            READY                  = 0x2D;
            PAPER_OUT              = 0x2E;
            PAPER_JAM              = 0x2F;
            REMOTE                 = 0x30;
            FORWARD                = 0x31;
            REVERSE                = 0x32;
            STOP                   = 0x33;
            REWIND                 = 0x34;
            FAST_FORWARD           = 0x35;
            PLAY                   = 0x36;
            PAUSE                  = 0x37;
            RECORD                 = 0x38;
            ERROR                  = 0x39;
            SELECTED_INDICATOR     = 0x3A;
            IN_USE_INDICATOR       = 0x3B;
            MULTI_MODE_INDICATOR   = 0x3C;
            INDICATOR_ON           = 0x3D;
            INDICATOR_FLASH        = 0x3E;
            INDICATOR_SLOW_BLINK   = 0x3F;
            INDICATOR_FAST_BLINK   = 0x40;
            INDICATOR_OFF          = 0x41;
            FLASH_ON_TIME          = 0x42;
            SLOW_BLINK_ON_TIME     = 0x43;
            SLOW_BLINK_OFF_TIME    = 0x44;
            FAST_BLINK_ON_TIME     = 0x45;
            FAST_BLINK_OFF_TIME    = 0x46;
            INDICATOR_COLOR        = 0x47;
            RED                    = 0x48;
            GREEN                  = 0x49;
            AMBER                  = 0x4A;
            GENERIC_INDICATOR      = 0x4B;
            SYSTEM_SUSPEND         = 0x4C;
            EXTERNAL_POWER         = 0x4D;
            
        },
    },

    -- nothing here
    [0x09] = {
        name = "BUTTON",
        usage = enum {

        },
    },

    -- nothing here
    [0x0A] = {
        name = "ORDINAL",
        usage = enum {

        },
    },

    [0x0B] = {
        name = "TELEPHONY",
        usage = enum {
            PHONE                   = 0x01;
            ANSWERING_MACHINE       = 0x02;
            MESSAGE_CONTROLS        = 0x03;
            HANDSET                 = 0x04;
            HEADSET                 = 0x05;
            KEYPAD                  = 0x06;
            PROGRAMMABLE_BUTTON     = 0x07;
            REDIAL                  = 0x24;
            TRANSFER                = 0x25;
            DROP                    = 0x26;
            LINE                    = 0x2A;
            RING_ENABLE             = 0x2D;
            SEND                    = 0x31;
            KEYPAD_0                = 0xB0;
            KEYPAD_D                = 0xBF;
            HOST_AVAILABLE          = 0xF1;
            
        },
    },

    [0x0C] = {
        name = "CONSUMER",
        usage = enum {
            CONSUMER_CTRL                      = 0x01;

            -- channel
            CHANNEL_INCREMENT        = 0x9C;
            CHANNEL_DECREMENT        = 0x9D;
            
            -- transport control
            PLAY                     = 0xB0;
            PAUSE                    = 0xB1;
            RECORD                   = 0xB2;
            FAST_FORWARD             = 0xB3;
            REWIND                   = 0xB4;
            SCAN_NEXT_TRACK          = 0xB5;
            SCAN_PREV_TRACK          = 0xB6;
            STOP                     = 0xB7;
            PLAY_PAUSE               = 0xCD;
            
            -- GameDVR
            GAMEDVR_OPEN_GAMEBAR     = 0xD0;
            GAMEDVR_TOGGLE_RECORD    = 0xD1;
            GAMEDVR_RECORD_CLIP      = 0xD2;
            GAMEDVR_SCREENSHOT       = 0xD3;
            GAMEDVR_TOGGLE_INDICATOR = 0xD4;
            GAMEDVR_TOGGLE_MICROPHONE = 0xD5;
            GAMEDVR_TOGGLE_CAMERA    = 0xD6;
            GAMEDVR_TOGGLE_BROADCAST = 0xD7;
            
            -- audio
            VOLUME                   = 0xE0;
            BALANCE                  = 0xE1;
            MUTE                     = 0xE2;
            BASS                     = 0xE3;
            TREBLE                   = 0xE4;
            BASS_BOOST               = 0xE5;
            SURROUND_MODE            = 0xE6;
            LOUDNESS                 = 0xE7;
            MPX                      = 0xE8;
            VOLUME_INCREMENT         = 0xE9;
            VOLUME_DECREMENT         = 0xEA;
            
            -- supplementary audio
            BASS_INCREMENT           = 0x152;
            BASS_DECREMENT           = 0x153;
            TREBLE_INCREMENT         = 0x154;
            TREBLE_DECREMENT         = 0x155;
            
            -- Application Launch
            AL_CONFIGURATION         = 0x183;
            AL_EMAIL                 = 0x18A;
            AL_CALCULATOR            = 0x192;
            AL_BROWSER               = 0x194;
            AL_SEARCH                = 0x1C6;
            
            -- Application Control
            AC_SEARCH                = 0x221;
            AC_GOTO                  = 0x222;
            AC_HOME                  = 0x223;
            AC_BACK                  = 0x224;
            AC_FORWARD               = 0x225;
            AC_STOP                  = 0x226;
            AC_REFRESH               = 0x227;
            AC_PREVIOUS              = 0x228;
            AC_NEXT                  = 0x229;
            AC_BOOKMARKS             = 0x22A;
            AC_PAN                   = 0x238;
            
            -- Keyboard Extended Attributes (defined on consumer page in HUTRR42;
            EXTENDED_KEYBOARD_ATTRIBUTES_COLLECTION      = 0x2C0;
            KEYBOARD_FORM_FACTOR                         = 0x2C1;
            KEYBOARD_KEY_TYPE                            = 0x2C2;
            KEYBOARD_PHYSICAL_LAYOUT                     = 0x2C3;
            VENDOR_SPECIFIC_KEYBOARD_PHYSICAL_LAYOUT     = 0x2C4;
            KEYBOARD_IETF_LANGUAGE_TAG_INDEX             = 0x2C5;
            IMPLEMENTED_KEYBOARD_INPUT_ASSIST_CONTROLS   = 0x2C6;
            
        },
    },

    [0x0D] = {
        name = "DIGITIZER",
        usage = enum {
            DIGITIZER               = 0x01;
            PEN                     = 0x02;
            LIGHT_PEN               = 0x03;
            TOUCH_SCREEN            = 0x04;
            TOUCH_PAD               = 0x05;
            WHITE_BOARD             = 0x06;
            COORD_MEASURING         = 0x07;
            ["3D_DIGITIZER"]            = 0x08;
            STEREO_PLOTTER          = 0x09;
            ARTICULATED_ARM         = 0x0A;
            ARMATURE                = 0x0B;
            MULTI_POINT             = 0x0C;
            FREE_SPACE_WAND         = 0x0D;
            STYLUS                  = 0x20;
            PUCK                    = 0x21;
            FINGER                  = 0x22;
            TABLET_FUNC_KEYS        = 0x39;
            PROG_CHANGE_KEYS        = 0x3A;
    
            TIP_PRESSURE            = 0x30;
            BARREL_PRESSURE         = 0x31;
            IN_RANGE                = 0x32;
            TOUCH                   = 0x33;
            UNTOUCH                 = 0x34;
            TAP                     = 0x35;
            QUALITY                 = 0x36;
            DATA_VALID              = 0x37;
            TRANSDUCER_INDEX        = 0x38;
            BATTERY_STRENGTH        = 0x3B;
            INVERT                  = 0x3C;
            X_TILT                  = 0x3D;
            Y_TILT                  = 0x3E;
            AZIMUTH                 = 0x3F;
            ALTITUDE                = 0x40;
            TWIST                   = 0x41;
            TIP_SWITCH              = 0x42;
            SECONDARY_TIP_SWITCH    = 0x43;
            BARREL_SWITCH           = 0x44;
            ERASER                  = 0x45;
            TABLET_PICK             = 0x46;
        },
    },
    
    [0x0E] = {
        name = "HAPTICS",
        usage = {
            SIMPLE_CONTROLLER         = 0x01;

WAVEFORM_LIST             = 0x10;
DURATION_LIST             = 0x11;

AUTO_TRIGGER              = 0x20;
MANUAL_TRIGGER            = 0x21;
AUTO_ASSOCIATED_CONTROL   = 0x22;
INTENSITY                 = 0x23;
REPEAT_COUNT              = 0x24;
RETRIGGER_PERIOD          = 0x25;
WAVEFORM_VENDOR_PAGE      = 0x26;
WAVEFORM_VENDOR_ID        = 0x27;
WAVEFORM_CUTOFF_TIME      = 0x28;

-- Waveform types
WAVEFORM_BEGIN            = 0x1000;
WAVEFORM_STOP             = 0x1001;
WAVEFORM_NULL             = 0x1002;
WAVEFORM_CLICK            = 0x1003;
WAVEFORM_BUZZ             = 0x1004;
WAVEFORM_RUMBLE           = 0x1005;
WAVEFORM_PRESS            = 0x1006;
WAVEFORM_RELEASE          = 0x1007;
WAVEFORM_END              = 0x1FFF;

WAVEFORM_VENDOR_BEGIN     = 0x2000;
WAVEFORM_VENDOR_END       = 0x2FFF;

        },
    },

    -- nothing here
    [0x0F] = {
        name = "PID",
        usage = enum {},
    },

    -- nothing here
    [0x10] = {
        name = "UNICODE",
        usage = enum {},
    },

    -- alphanumeric display
    [0x14] = {
        name = "ALPHANUMERIC",
        usage = enum {
            ALPHANUMERIC_DISPLAY            = 0x01;
            BITMAPPED_DISPLAY               = 0x02;
            DISPLAY_ATTRIBUTES_REPORT       = 0x20;
            DISPLAY_CONTROL_REPORT          = 0x24;
            CHARACTER_REPORT                = 0x2B;
            DISPLAY_STATUS                  = 0x2D;
            CURSOR_POSITION_REPORT          = 0x32;
            FONT_REPORT                     = 0x3B;
            FONT_DATA                       = 0x3C;
            CHARACTER_ATTRIBUTE             = 0x48;
            PALETTE_REPORT                  = 0x85;
            PALETTE_DATA                    = 0x88;
            BLIT_REPORT                     = 0x8A;
            BLIT_DATA                       = 0x8F;
            SOFT_BUTTON                     = 0x90;
            
            ASCII_CHARACTER_SET             = 0x21;
            DATA_READ_BACK                  = 0x22;
            FONT_READ_BACK                  = 0x23;
            CLEAR_DISPLAY                   = 0x25;
            DISPLAY_ENABLE                  = 0x26;
            SCREEN_SAVER_DELAY              = 0x27;
            SCREEN_SAVER_ENABLE             = 0x28;
            VERTICAL_SCROLL                 = 0x29;
            HORIZONTAL_SCROLL               = 0x2A;
            DISPLAY_DATA                    = 0x2C;
            STATUS_NOT_READY                = 0x2E;
            STATUS_READY                    = 0x2F;
            ERR_NOT_A_LOADABLE_CHARACTER    = 0x30;
            ERR_FONT_DATA_CANNOT_BE_READ    = 0x31;
            ROW                             = 0x33;
            COLUMN                          = 0x34;
            ROWS                            = 0x35;
            COLUMNS                         = 0x36;
            CURSOR_PIXEL_POSITIONING        = 0x37;
            CURSOR_MODE                     = 0x38;
            CURSOR_ENABLE                   = 0x39;
            CURSOR_BLINK                    = 0x3A;
            CHAR_WIDTH                      = 0x3D;
            CHAR_HEIGHT                     = 0x3E;
            CHAR_SPACING_HORIZONTAL         = 0x3F;
            CHAR_SPACING_VERTICAL           = 0x40;
            UNICODE_CHAR_SET                = 0x41;
            FONT_7_SEGMENT                  = 0x42;
            ["7_SEGMENT_DIRECT_MAP"]            = 0x43;
            FONT_14_SEGMENT                 = 0x44;
            ["14_SEGMENT_DIRECT_MAP"]           = 0x45;
            DISPLAY_BRIGHTNESS              = 0x46;
            DISPLAY_CONTRAST                = 0x47;
            ATTRIBUTE_READBACK              = 0x49;
            ATTRIBUTE_DATA                  = 0x4A;
            CHAR_ATTR_ENHANCE               = 0x4B;
            CHAR_ATTR_UNDERLINE             = 0x4C;
            CHAR_ATTR_BLINK                 = 0x4D;
            BITMAP_SIZE_X                   = 0x80;
            BITMAP_SIZE_Y                   = 0x81;
            BIT_DEPTH_FORMAT                = 0x83;
            DISPLAY_ORIENTATION             = 0x84;
            PALETTE_DATA_SIZE               = 0x86;
            PALETTE_DATA_OFFSET             = 0x87;
            BLIT_RECTANGLE_X1               = 0x8B;
            BLIT_RECTANGLE_Y1               = 0x8C;
            BLIT_RECTANGLE_X2               = 0x8D;
            BLIT_RECTANGLE_Y2               = 0x8E;
            SOFT_BUTTON_ID                  = 0x91;
            SOFT_BUTTON_SIDE                = 0x92;
            SOFT_BUTTON_OFFSET1             = 0x93;
            SOFT_BUTTON_OFFSET2             = 0x94;
            SOFT_BUTTON_REPORT              = 0x95;
            
        },
    },

    -- nothing here
    [0x20] = {
        name = "SENSOR",
        usage = enum {},
    },

    -- LAMPARRAY
    [0x59] = {
        name = "LIGHTING_ILLUMINATION",
        usage = enum {
            LAMPARRAY                                             = 0x01;
            ATTRBIUTES_REPORT                           = 0x02;
            LAMP_COUNT                                  = 0x03;
            BOUNDING_BOX_WIDTH_IN_MICROMETERS           = 0x04;
            BOUNDING_BOX_HEIGHT_IN_MICROMETERS          = 0x05;
            BOUNDING_BOX_DEPTH_IN_MICROMETERS           = 0x06;
            KIND                                        = 0x07;
            MIN_UPDATE_INTERVAL_IN_MICROSECONDS         = 0x08;
            
            LAMP_ATTRIBUTES_REQUEST_REPORT              = 0x20;
            LAMP_ID                                     = 0x21;
            LAMP_ATTRIBUTES_RESPONSE_REPORT             = 0x22;
            POSITION_X_IN_MICROMETERS                   = 0x23;
            POSITION_Y_IN_MICROMETERS                   = 0x24;
            POSITION_Z_IN_MICROMETERS                   = 0x25;
            LAMP_PURPOSES                               = 0x26;
            UPDATE_LATENCY_IN_MICROSECONDS              = 0x27;
            RED_LEVEL_COUNT                             = 0x28;
            GREEN_LEVEL_COUNT                           = 0x29;
            BLUE_LEVEL_COUNT                            = 0x2A;
            INTENSITY_LEVEL_COUNT                       = 0x2B;
            IS_PROGRAMMABLE                             = 0x2C;
            INPUT_BINDING                               = 0x2D;

            LAMP_MULTI_UPDATE_REPORT                    = 0x50;
            LAMP_RED_UPDATE_CHANNEL                     = 0x51;
            LAMP_GREEN_UPDATE_CHANNEL                   = 0x52;
            LAMP_BLUE_UPDATE_CHANNEL                    = 0x53;
            LAMP_INTENSITY_UPDATE_CHANNEL               = 0x54;
            LAMP_UPDATE_FLAGS                           = 0x55;
            
            LAMP_RANGE_UPDATE_REPORT                    = 0x60;
            LAMP_ID_START                               = 0x61;
            LAMP_ID_END                                 = 0x62;
            
            CONTROL_REPORT                              = 0x70;
            AUTONOMOUS_MODE                             = 0x71;
        }
    },

    [0x8C] = {
        name = "BARCODE_SCANNER",
        usage = enum {},
    },
    [0x8D] = {
        name = "WEIGHING_DEVICE",
        usage = enum {},
    },

    [0x8E] = {
        name = "MAGNETIC_STRIPE_READER",
        usage = enum {},
    },

    [0x90] = {
        name = "CAMERA_CONTROL",
        usage = enum {
            AUTO_FOCUS                 = 0x20;
            SHUTTER                    = 0x21;
        },
    },

    [0x91] = {
        name = "ARCADE",
        usage = enum {},
    },

    [0xFFF3] = {
        name = "MICROSOFT_BLUETOOTH_HANDSFREE",
        usage = enum {
            DIALNUMBER              = 0x21;
            DIALMEMORY              = 0x22;
        },
    },

    [0xFF00] = {
        name = "VENDOR_DEFINED_BEGIN",
        usage = enum {},
    },

    [0xFFFF] = {
        name = "VENDOR_DEFINED_END",
        usage = enum {},
    },
}

function hidusagedb.lookupUsage(self, usagePage, usage)
    local page = self[usagePage]

    if not page then return string.format("0x%x", usage) end

    return page.usage[usage] or string.format("0x%x", usage)
end



return hidusagedb
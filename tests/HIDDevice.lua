-- https://docs.microsoft.com/en-us/windows-hardware/drivers/hid/initializing-hid-reports
-- https://docs.microsoft.com/en-us/windows-hardware/drivers/hid/hidclass-hardware-ids-for-top-level-collections

--[[
    Windows Top-Level Collections
Device Type         Usage   Usage
                    Page    ID
    Pointer         0x01    0x01
    Mouse           0x01    0x02
    Joystick        0x01    0x04
    Game pad        0x01    0x05
    Keyboard        0x01    0x06
    Keypad          0x01    0x07
    System Control  0x01    0x80
    Consumer Audio  0x0C    0x01
]]
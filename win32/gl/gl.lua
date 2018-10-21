--[[
    This is the basic Windows OpenGL interfacE;
    What's represented in Windows is the 'old' style, heavy 
    on state management of version 1.1 OpenGL  This is not 
    the place to go for in depth OpenGL.

    lj2khronos is a much deeper treatment of all things OpenGL,
    but if you just want to try a little bit out, this will
    get you going.
]]

local ffi = require("ffi")


ffi.cdef[[
typedef unsigned int GLenum;
typedef unsigned char GLboolean;
typedef unsigned int GLbitfield;
typedef signed char GLbyte;
typedef short GLshort;
typedef int GLint;
typedef int GLsizei;
typedef unsigned char GLubyte;
typedef unsigned short GLushort;
typedef unsigned int GLuint;
typedef float GLfloat;
typedef float GLclampf;
typedef double GLdouble;
typedef double GLclampd;
typedef void GLvoid;
]]

ffi.cdef[[
/*************************************************************/

/* Version */
static const int GL_VERSION_1_1                 =   1;
]]

ffi.cdef[[
/* AccumOp */
static const int GL_ACCUM                         = 0x0100;
static const int GL_LOAD                          = 0x0101;
static const int GL_RETURN                        = 0x0102;
static const int GL_MULT                          = 0x0103;
static const int GL_ADD                           = 0x0104;
]]

ffi.cdef[[
/* AlphaFunction */
static const int GL_NEVER                         = 0x0200;
static const int GL_LESS                          = 0x0201;
static const int GL_EQUAL                         = 0x0202;
static const int GL_LEQUAL                        = 0x0203;
static const int GL_GREATER                       = 0x0204;
static const int GL_NOTEQUAL                      = 0x0205;
static const int GL_GEQUAL                        = 0x0206;
static const int GL_ALWAYS                        = 0x0207;
]]

ffi.cdef[[
/* AttribMask */
static const int GL_CURRENT_BIT                   = 0x00000001;
static const int GL_POINT_BIT                     = 0x00000002;
static const int GL_LINE_BIT                      = 0x00000004;
static const int GL_POLYGON_BIT                   = 0x00000008;
static const int GL_POLYGON_STIPPLE_BIT           = 0x00000010;
static const int GL_PIXEL_MODE_BIT                = 0x00000020;
static const int GL_LIGHTING_BIT                  = 0x00000040;
static const int GL_FOG_BIT                       = 0x00000080;
static const int GL_DEPTH_BUFFER_BIT              = 0x00000100;
static const int GL_ACCUM_BUFFER_BIT              = 0x00000200;
static const int GL_STENCIL_BUFFER_BIT            = 0x00000400;
static const int GL_VIEWPORT_BIT                  = 0x00000800;
static const int GL_TRANSFORM_BIT                 = 0x00001000;
static const int GL_ENABLE_BIT                    = 0x00002000;
static const int GL_COLOR_BUFFER_BIT              = 0x00004000;
static const int GL_HINT_BIT                      = 0x00008000;
static const int GL_EVAL_BIT                      = 0x00010000;
static const int GL_LIST_BIT                      = 0x00020000;
static const int GL_TEXTURE_BIT                   = 0x00040000;
static const int GL_SCISSOR_BIT                   = 0x00080000;
static const int GL_ALL_ATTRIB_BITS               = 0x000ffffF;
]]

ffi.cdef[[
/* BeginMode */
static const int GL_POINTS                        = 0x0000;
static const int GL_LINES                         = 0x0001;
static const int GL_LINE_LOOP                     = 0x0002;
static const int GL_LINE_STRIP                    = 0x0003;
static const int GL_TRIANGLES                     = 0x0004;
static const int GL_TRIANGLE_STRIP                = 0x0005;
static const int GL_TRIANGLE_FAN                  = 0x0006;
static const int GL_QUADS                         = 0x0007;
static const int GL_QUAD_STRIP                    = 0x0008;
static const int GL_POLYGON                       = 0x0009;
]]

ffi.cdef[[
/* BlendingFactorDest */
static const int GL_ZERO                          = 0;
static const int GL_ONE                           = 1;
static const int GL_SRC_COLOR                     = 0x0300;
static const int GL_ONE_MINUS_SRC_COLOR           = 0x0301;
static const int GL_SRC_ALPHA                     = 0x0302;
static const int GL_ONE_MINUS_SRC_ALPHA           = 0x0303;
static const int GL_DST_ALPHA                     = 0x0304;
static const int GL_ONE_MINUS_DST_ALPHA           = 0x0305;

/* BlendingFactorSrc */
/*      GL_ZERO */
/*      GL_ONE */
static const int GL_DST_COLOR                     = 0x0306;
static const int GL_ONE_MINUS_DST_COLOR           = 0x0307;
static const int GL_SRC_ALPHA_SATURATE            = 0x0308;
/*      GL_SRC_ALPHA */
/*      GL_ONE_MINUS_SRC_ALPHA */
/*      GL_DST_ALPHA */
/*      GL_ONE_MINUS_DST_ALPHA */
]]

ffi.cdef[[
/* Boolean */
static const int GL_TRUE                          = 1;
static const int GL_FALSE                         = 0;
]]

ffi.cdef[[
/* ClearBufferMask */
/*      GL_COLOR_BUFFER_BIT */
/*      GL_ACCUM_BUFFER_BIT */
/*      GL_STENCIL_BUFFER_BIT */
/*      GL_DEPTH_BUFFER_BIT */

/* ClientArrayType */
/*      GL_VERTEX_ARRAY */
/*      GL_NORMAL_ARRAY */
/*      GL_COLOR_ARRAY */
/*      GL_INDEX_ARRAY */
/*      GL_TEXTURE_COORD_ARRAY */
/*      GL_EDGE_FLAG_ARRAY */

/* ClipPlaneName */
static const int GL_CLIP_PLANE0                   = 0x3000;
static const int GL_CLIP_PLANE1                   = 0x3001;
static const int GL_CLIP_PLANE2                   = 0x3002;
static const int GL_CLIP_PLANE3                   = 0x3003;
static const int GL_CLIP_PLANE4                   = 0x3004;
static const int GL_CLIP_PLANE5                   = 0x3005;

/* ColorMaterialFace */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_FRONT_AND_BACK */

/* ColorMaterialParameter */
/*      GL_AMBIENT */
/*      GL_DIFFUSE */
/*      GL_SPECULAR */
/*      GL_EMISSION */
/*      GL_AMBIENT_AND_DIFFUSE */

/* ColorPointerType */
/*      GL_BYTE */
/*      GL_UNSIGNED_BYTE */
/*      GL_SHORT */
/*      GL_UNSIGNED_SHORT */
/*      GL_INT */
/*      GL_UNSIGNED_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* CullFaceMode */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_FRONT_AND_BACK */

/* DataType */
static const int GL_BYTE                          = 0x1400;
static const int GL_UNSIGNED_BYTE                 = 0x1401;
static const int GL_SHORT                         = 0x1402;
static const int GL_UNSIGNED_SHORT                = 0x1403;
static const int GL_INT                           = 0x1404;
static const int GL_UNSIGNED_INT                  = 0x1405;
static const int GL_FLOAT                         = 0x1406;
static const int GL_2_BYTES                       = 0x1407;
static const int GL_3_BYTES                       = 0x1408;
static const int GL_4_BYTES                       = 0x1409;
static const int GL_DOUBLE                        = 0x140A;

/* DepthFunction */
/*      GL_NEVER */
/*      GL_LESS */
/*      GL_EQUAL */
/*      GL_LEQUAL */
/*      GL_GREATER */
/*      GL_NOTEQUAL */
/*      GL_GEQUAL */
/*      GL_ALWAYS */

/* DrawBufferMode */
static const int GL_NONE                          = 0;
static const int GL_FRONT_LEFT                    = 0x0400;
static const int GL_FRONT_RIGHT                   = 0x0401;
static const int GL_BACK_LEFT                     = 0x0402;
static const int GL_BACK_RIGHT                    = 0x0403;
static const int GL_FRONT                         = 0x0404;
static const int GL_BACK                          = 0x0405;
static const int GL_LEFT                          = 0x0406;
static const int GL_RIGHT                         = 0x0407;
static const int GL_FRONT_AND_BACK                = 0x0408;
static const int GL_AUX0                          = 0x0409;
static const int GL_AUX1                          = 0x040A;
static const int GL_AUX2                          = 0x040B;
static const int GL_AUX3                          = 0x040C;

/* Enable */
/*      GL_FOG */
/*      GL_LIGHTING */
/*      GL_TEXTURE_1D */
/*      GL_TEXTURE_2D */
/*      GL_LINE_STIPPLE */
/*      GL_POLYGON_STIPPLE */
/*      GL_CULL_FACE */
/*      GL_ALPHA_TEST */
/*      GL_BLEND */
/*      GL_INDEX_LOGIC_OP */
/*      GL_COLOR_LOGIC_OP */
/*      GL_DITHER */
/*      GL_STENCIL_TEST */
/*      GL_DEPTH_TEST */
/*      GL_CLIP_PLANE0 */
/*      GL_CLIP_PLANE1 */
/*      GL_CLIP_PLANE2 */
/*      GL_CLIP_PLANE3 */
/*      GL_CLIP_PLANE4 */
/*      GL_CLIP_PLANE5 */
/*      GL_LIGHT0 */
/*      GL_LIGHT1 */
/*      GL_LIGHT2 */
/*      GL_LIGHT3 */
/*      GL_LIGHT4 */
/*      GL_LIGHT5 */
/*      GL_LIGHT6 */
/*      GL_LIGHT7 */
/*      GL_TEXTURE_GEN_S */
/*      GL_TEXTURE_GEN_T */
/*      GL_TEXTURE_GEN_R */
/*      GL_TEXTURE_GEN_Q */
/*      GL_MAP1_VERTEX_3 */
/*      GL_MAP1_VERTEX_4 */
/*      GL_MAP1_COLOR_4 */
/*      GL_MAP1_INDEX */
/*      GL_MAP1_NORMAL */
/*      GL_MAP1_TEXTURE_COORD_1 */
/*      GL_MAP1_TEXTURE_COORD_2 */
/*      GL_MAP1_TEXTURE_COORD_3 */
/*      GL_MAP1_TEXTURE_COORD_4 */
/*      GL_MAP2_VERTEX_3 */
/*      GL_MAP2_VERTEX_4 */
/*      GL_MAP2_COLOR_4 */
/*      GL_MAP2_INDEX */
/*      GL_MAP2_NORMAL */
/*      GL_MAP2_TEXTURE_COORD_1 */
/*      GL_MAP2_TEXTURE_COORD_2 */
/*      GL_MAP2_TEXTURE_COORD_3 */
/*      GL_MAP2_TEXTURE_COORD_4 */
/*      GL_POINT_SMOOTH */
/*      GL_LINE_SMOOTH */
/*      GL_POLYGON_SMOOTH */
/*      GL_SCISSOR_TEST */
/*      GL_COLOR_MATERIAL */
/*      GL_NORMALIZE */
/*      GL_AUTO_NORMAL */
/*      GL_VERTEX_ARRAY */
/*      GL_NORMAL_ARRAY */
/*      GL_COLOR_ARRAY */
/*      GL_INDEX_ARRAY */
/*      GL_TEXTURE_COORD_ARRAY */
/*      GL_EDGE_FLAG_ARRAY */
/*      GL_POLYGON_OFFSET_POINT */
/*      GL_POLYGON_OFFSET_LINE */
/*      GL_POLYGON_OFFSET_FILL */

/* ErrorCode */
static const int GL_NO_ERROR                      = 0;
static const int GL_INVALID_ENUM                  = 0x0500;
static const int GL_INVALID_VALUE                 = 0x0501;
static const int GL_INVALID_OPERATION             = 0x0502;
static const int GL_STACK_OVERFLOW                = 0x0503;
static const int GL_STACK_UNDERFLOW               = 0x0504;
static const int GL_OUT_OF_MEMORY                 = 0x0505;

/* FeedBackMode */
static const int GL_2D                            = 0x0600;
static const int GL_3D                            = 0x0601;
static const int GL_3D_COLOR                      = 0x0602;
static const int GL_3D_COLOR_TEXTURE              = 0x0603;
static const int GL_4D_COLOR_TEXTURE              = 0x0604;

/* FeedBackToken */
static const int GL_PASS_THROUGH_TOKEN            = 0x0700;
static const int GL_POINT_TOKEN                   = 0x0701;
static const int GL_LINE_TOKEN                    = 0x0702;
static const int GL_POLYGON_TOKEN                 = 0x0703;
static const int GL_BITMAP_TOKEN                  = 0x0704;
static const int GL_DRAW_PIXEL_TOKEN              = 0x0705;
static const int GL_COPY_PIXEL_TOKEN              = 0x0706;
static const int GL_LINE_RESET_TOKEN              = 0x0707;

/* FogMode */
/*      GL_LINEAR */
static const int GL_EXP                           = 0x0800;
static const int GL_EXP2                          = 0x0801;


/* FogParameter */
/*      GL_FOG_COLOR */
/*      GL_FOG_DENSITY */
/*      GL_FOG_END */
/*      GL_FOG_INDEX */
/*      GL_FOG_MODE */
/*      GL_FOG_START */

/* FrontFaceDirection */
static const int GL_CW                            = 0x0900;
static const int GL_CCW                           = 0x0901;

/* GetMapTarget */
static const int GL_COEFF                         = 0x0A00;
static const int GL_ORDER                         = 0x0A01;
static const int GL_DOMAIN                        = 0x0A02;

/* GetPixelMap */
/*      GL_PIXEL_MAP_I_TO_I */
/*      GL_PIXEL_MAP_S_TO_S */
/*      GL_PIXEL_MAP_I_TO_R */
/*      GL_PIXEL_MAP_I_TO_G */
/*      GL_PIXEL_MAP_I_TO_B */
/*      GL_PIXEL_MAP_I_TO_A */
/*      GL_PIXEL_MAP_R_TO_R */
/*      GL_PIXEL_MAP_G_TO_G */
/*      GL_PIXEL_MAP_B_TO_B */
/*      GL_PIXEL_MAP_A_TO_A */

/* GetPointerTarget */
/*      GL_VERTEX_ARRAY_POINTER */
/*      GL_NORMAL_ARRAY_POINTER */
/*      GL_COLOR_ARRAY_POINTER */
/*      GL_INDEX_ARRAY_POINTER */
/*      GL_TEXTURE_COORD_ARRAY_POINTER */
/*      GL_EDGE_FLAG_ARRAY_POINTER */

/* GetTarget */
static const int GL_CURRENT_COLOR                 = 0x0B00;
static const int GL_CURRENT_INDEX                 = 0x0B01;
static const int GL_CURRENT_NORMAL                = 0x0B02;
static const int GL_CURRENT_TEXTURE_COORDS        = 0x0B03;
static const int GL_CURRENT_RASTER_COLOR          = 0x0B04;
static const int GL_CURRENT_RASTER_INDEX          = 0x0B05;
static const int GL_CURRENT_RASTER_TEXTURE_COORDS = 0x0B06;
static const int GL_CURRENT_RASTER_POSITION       = 0x0B07;
static const int GL_CURRENT_RASTER_POSITION_VALID = 0x0B08;
static const int GL_CURRENT_RASTER_DISTANCE       = 0x0B09;
static const int GL_POINT_SMOOTH                  = 0x0B10;
static const int GL_POINT_SIZE                    = 0x0B11;
static const int GL_POINT_SIZE_RANGE              = 0x0B12;
static const int GL_POINT_SIZE_GRANULARITY        = 0x0B13;
static const int GL_LINE_SMOOTH                   = 0x0B20;
static const int GL_LINE_WIDTH                    = 0x0B21;
static const int GL_LINE_WIDTH_RANGE              = 0x0B22;
static const int GL_LINE_WIDTH_GRANULARITY        = 0x0B23;
static const int GL_LINE_STIPPLE                  = 0x0B24;
static const int GL_LINE_STIPPLE_PATTERN          = 0x0B25;
static const int GL_LINE_STIPPLE_REPEAT           = 0x0B26;
static const int GL_LIST_MODE                     = 0x0B30;
static const int GL_MAX_LIST_NESTING              = 0x0B31;
static const int GL_LIST_BASE                     = 0x0B32;
static const int GL_LIST_INDEX                    = 0x0B33;
static const int GL_POLYGON_MODE                  = 0x0B40;
static const int GL_POLYGON_SMOOTH                = 0x0B41;
static const int GL_POLYGON_STIPPLE               = 0x0B42;
static const int GL_EDGE_FLAG                     = 0x0B43;
static const int GL_CULL_FACE                     = 0x0B44;
static const int GL_CULL_FACE_MODE                = 0x0B45;
static const int GL_FRONT_FACE                    = 0x0B46;
static const int GL_LIGHTING                      = 0x0B50;
static const int GL_LIGHT_MODEL_LOCAL_VIEWER      = 0x0B51;
static const int GL_LIGHT_MODEL_TWO_SIDE          = 0x0B52;
static const int GL_LIGHT_MODEL_AMBIENT           = 0x0B53;
static const int GL_SHADE_MODEL                   = 0x0B54;
static const int GL_COLOR_MATERIAL_FACE           = 0x0B55;
static const int GL_COLOR_MATERIAL_PARAMETER      = 0x0B56;
static const int GL_COLOR_MATERIAL                = 0x0B57;
static const int GL_FOG                           = 0x0B60;
static const int GL_FOG_INDEX                     = 0x0B61;
static const int GL_FOG_DENSITY                   = 0x0B62;
static const int GL_FOG_START                     = 0x0B63;
static const int GL_FOG_END                       = 0x0B64;
static const int GL_FOG_MODE                      = 0x0B65;
static const int GL_FOG_COLOR                     = 0x0B66;
static const int GL_DEPTH_RANGE                   = 0x0B70;
static const int GL_DEPTH_TEST                    = 0x0B71;
static const int GL_DEPTH_WRITEMASK               = 0x0B72;
static const int GL_DEPTH_CLEAR_VALUE             = 0x0B73;
static const int GL_DEPTH_FUNC                    = 0x0B74;
static const int GL_ACCUM_CLEAR_VALUE             = 0x0B80;
static const int GL_STENCIL_TEST                  = 0x0B90;
static const int GL_STENCIL_CLEAR_VALUE           = 0x0B91;
static const int GL_STENCIL_FUNC                  = 0x0B92;
static const int GL_STENCIL_VALUE_MASK            = 0x0B93;
static const int GL_STENCIL_FAIL                  = 0x0B94;
static const int GL_STENCIL_PASS_DEPTH_FAIL       = 0x0B95;
static const int GL_STENCIL_PASS_DEPTH_PASS       = 0x0B96;
static const int GL_STENCIL_REF                   = 0x0B97;
static const int GL_STENCIL_WRITEMASK             = 0x0B98;
static const int GL_MATRIX_MODE                   = 0x0BA0;
static const int GL_NORMALIZE                     = 0x0BA1;
static const int GL_VIEWPORT                      = 0x0BA2;
static const int GL_MODELVIEW_STACK_DEPTH         = 0x0BA3;
static const int GL_PROJECTION_STACK_DEPTH        = 0x0BA4;
static const int GL_TEXTURE_STACK_DEPTH           = 0x0BA5;
static const int GL_MODELVIEW_MATRIX              = 0x0BA6;
static const int GL_PROJECTION_MATRIX             = 0x0BA7;
static const int GL_TEXTURE_MATRIX                = 0x0BA8;
static const int GL_ATTRIB_STACK_DEPTH            = 0x0BB0;
static const int GL_CLIENT_ATTRIB_STACK_DEPTH     = 0x0BB1;
static const int GL_ALPHA_TEST                    = 0x0BC0;
static const int GL_ALPHA_TEST_FUNC               = 0x0BC1;
static const int GL_ALPHA_TEST_REF                = 0x0BC2;
static const int GL_DITHER                        = 0x0BD0;
static const int GL_BLEND_DST                     = 0x0BE0;
static const int GL_BLEND_SRC                     = 0x0BE1;
static const int GL_BLEND                         = 0x0BE2;
static const int GL_LOGIC_OP_MODE                 = 0x0BF0;
static const int GL_INDEX_LOGIC_OP                = 0x0BF1;
static const int GL_COLOR_LOGIC_OP                = 0x0BF2;
static const int GL_AUX_BUFFERS                   = 0x0C00;
static const int GL_DRAW_BUFFER                   = 0x0C01;
static const int GL_READ_BUFFER                   = 0x0C02;
static const int GL_SCISSOR_BOX                   = 0x0C10;
static const int GL_SCISSOR_TEST                  = 0x0C11;
static const int GL_INDEX_CLEAR_VALUE             = 0x0C20;
static const int GL_INDEX_WRITEMASK               = 0x0C21;
static const int GL_COLOR_CLEAR_VALUE             = 0x0C22;
static const int GL_COLOR_WRITEMASK               = 0x0C23;
static const int GL_INDEX_MODE                    = 0x0C30;
static const int GL_RGBA_MODE                     = 0x0C31;
static const int GL_DOUBLEBUFFER                  = 0x0C32;
static const int GL_STEREO                        = 0x0C33;
static const int GL_RENDER_MODE                   = 0x0C40;
static const int GL_PERSPECTIVE_CORRECTION_HINT   = 0x0C50;
static const int GL_POINT_SMOOTH_HINT             = 0x0C51;
static const int GL_LINE_SMOOTH_HINT              = 0x0C52;
static const int GL_POLYGON_SMOOTH_HINT           = 0x0C53;
static const int GL_FOG_HINT                      = 0x0C54;
static const int GL_TEXTURE_GEN_S                 = 0x0C60;
static const int GL_TEXTURE_GEN_T                 = 0x0C61;
static const int GL_TEXTURE_GEN_R                 = 0x0C62;
static const int GL_TEXTURE_GEN_Q                 = 0x0C63;
static const int GL_PIXEL_MAP_I_TO_I              = 0x0C70;
static const int GL_PIXEL_MAP_S_TO_S              = 0x0C71;
static const int GL_PIXEL_MAP_I_TO_R              = 0x0C72;
static const int GL_PIXEL_MAP_I_TO_G              = 0x0C73;
static const int GL_PIXEL_MAP_I_TO_B              = 0x0C74;
static const int GL_PIXEL_MAP_I_TO_A              = 0x0C75;
static const int GL_PIXEL_MAP_R_TO_R              = 0x0C76;
static const int GL_PIXEL_MAP_G_TO_G              = 0x0C77;
static const int GL_PIXEL_MAP_B_TO_B              = 0x0C78;
static const int GL_PIXEL_MAP_A_TO_A              = 0x0C79;
static const int GL_PIXEL_MAP_I_TO_I_SIZE         = 0x0CB0;
static const int GL_PIXEL_MAP_S_TO_S_SIZE         = 0x0CB1;
static const int GL_PIXEL_MAP_I_TO_R_SIZE         = 0x0CB2;
static const int GL_PIXEL_MAP_I_TO_G_SIZE         = 0x0CB3;
static const int GL_PIXEL_MAP_I_TO_B_SIZE         = 0x0CB4;
static const int GL_PIXEL_MAP_I_TO_A_SIZE         = 0x0CB5;
static const int GL_PIXEL_MAP_R_TO_R_SIZE         = 0x0CB6;
static const int GL_PIXEL_MAP_G_TO_G_SIZE         = 0x0CB7;
static const int GL_PIXEL_MAP_B_TO_B_SIZE         = 0x0CB8;
static const int GL_PIXEL_MAP_A_TO_A_SIZE         = 0x0CB9;
static const int GL_UNPACK_SWAP_BYTES             = 0x0CF0;
static const int GL_UNPACK_LSB_FIRST              = 0x0CF1;
static const int GL_UNPACK_ROW_LENGTH             = 0x0CF2;
static const int GL_UNPACK_SKIP_ROWS              = 0x0CF3;
static const int GL_UNPACK_SKIP_PIXELS            = 0x0CF4;
static const int GL_UNPACK_ALIGNMENT              = 0x0CF5;
static const int GL_PACK_SWAP_BYTES               = 0x0D00;
static const int GL_PACK_LSB_FIRST                = 0x0D01;
static const int GL_PACK_ROW_LENGTH               = 0x0D02;
static const int GL_PACK_SKIP_ROWS                = 0x0D03;
static const int GL_PACK_SKIP_PIXELS              = 0x0D04;
static const int GL_PACK_ALIGNMENT                = 0x0D05;
static const int GL_MAP_COLOR                     = 0x0D10;
static const int GL_MAP_STENCIL                   = 0x0D11;
static const int GL_INDEX_SHIFT                   = 0x0D12;
static const int GL_INDEX_OFFSET                  = 0x0D13;
static const int GL_RED_SCALE                     = 0x0D14;
static const int GL_RED_BIAS                      = 0x0D15;
static const int GL_ZOOM_X                        = 0x0D16;
static const int GL_ZOOM_Y                        = 0x0D17;
static const int GL_GREEN_SCALE                   = 0x0D18;
static const int GL_GREEN_BIAS                    = 0x0D19;
static const int GL_BLUE_SCALE                    = 0x0D1A;
static const int GL_BLUE_BIAS                     = 0x0D1B;
static const int GL_ALPHA_SCALE                   = 0x0D1C;
static const int GL_ALPHA_BIAS                    = 0x0D1D;
static const int GL_DEPTH_SCALE                   = 0x0D1E;
static const int GL_DEPTH_BIAS                    = 0x0D1F;
static const int GL_MAX_EVAL_ORDER                = 0x0D30;
static const int GL_MAX_LIGHTS                    = 0x0D31;
static const int GL_MAX_CLIP_PLANES               = 0x0D32;
static const int GL_MAX_TEXTURE_SIZE              = 0x0D33;
static const int GL_MAX_PIXEL_MAP_TABLE           = 0x0D34;
static const int GL_MAX_ATTRIB_STACK_DEPTH        = 0x0D35;
static const int GL_MAX_MODELVIEW_STACK_DEPTH     = 0x0D36;
static const int GL_MAX_NAME_STACK_DEPTH          = 0x0D37;
static const int GL_MAX_PROJECTION_STACK_DEPTH    = 0x0D38;
static const int GL_MAX_TEXTURE_STACK_DEPTH       = 0x0D39;
static const int GL_MAX_VIEWPORT_DIMS             = 0x0D3A;
static const int GL_MAX_CLIENT_ATTRIB_STACK_DEPTH = 0x0D3B;
static const int GL_SUBPIXEL_BITS                 = 0x0D50;
static const int GL_INDEX_BITS                    = 0x0D51;
static const int GL_RED_BITS                      = 0x0D52;
static const int GL_GREEN_BITS                    = 0x0D53;
static const int GL_BLUE_BITS                     = 0x0D54;
static const int GL_ALPHA_BITS                    = 0x0D55;
static const int GL_DEPTH_BITS                    = 0x0D56;
static const int GL_STENCIL_BITS                  = 0x0D57;
static const int GL_ACCUM_RED_BITS                = 0x0D58;
static const int GL_ACCUM_GREEN_BITS              = 0x0D59;
static const int GL_ACCUM_BLUE_BITS               = 0x0D5A;
static const int GL_ACCUM_ALPHA_BITS              = 0x0D5B;
static const int GL_NAME_STACK_DEPTH              = 0x0D70;
static const int GL_AUTO_NORMAL                   = 0x0D80;
static const int GL_MAP1_COLOR_4                  = 0x0D90;
static const int GL_MAP1_INDEX                    = 0x0D91;
static const int GL_MAP1_NORMAL                   = 0x0D92;
static const int GL_MAP1_TEXTURE_COORD_1          = 0x0D93;
static const int GL_MAP1_TEXTURE_COORD_2          = 0x0D94;
static const int GL_MAP1_TEXTURE_COORD_3          = 0x0D95;
static const int GL_MAP1_TEXTURE_COORD_4          = 0x0D96;
static const int GL_MAP1_VERTEX_3                 = 0x0D97;
static const int GL_MAP1_VERTEX_4                 = 0x0D98;
static const int GL_MAP2_COLOR_4                  = 0x0DB0;
static const int GL_MAP2_INDEX                    = 0x0DB1;
static const int GL_MAP2_NORMAL                   = 0x0DB2;
static const int GL_MAP2_TEXTURE_COORD_1          = 0x0DB3;
static const int GL_MAP2_TEXTURE_COORD_2          = 0x0DB4;
static const int GL_MAP2_TEXTURE_COORD_3          = 0x0DB5;
static const int GL_MAP2_TEXTURE_COORD_4          = 0x0DB6;
static const int GL_MAP2_VERTEX_3                 = 0x0DB7;
static const int GL_MAP2_VERTEX_4                 = 0x0DB8;
static const int GL_MAP1_GRID_DOMAIN              = 0x0DD0;
static const int GL_MAP1_GRID_SEGMENTS            = 0x0DD1;
static const int GL_MAP2_GRID_DOMAIN              = 0x0DD2;
static const int GL_MAP2_GRID_SEGMENTS            = 0x0DD3;
static const int GL_TEXTURE_1D                    = 0x0DE0;
static const int GL_TEXTURE_2D                    = 0x0DE1;
static const int GL_FEEDBACK_BUFFER_POINTER       = 0x0DF0;
static const int GL_FEEDBACK_BUFFER_SIZE          = 0x0DF1;
static const int GL_FEEDBACK_BUFFER_TYPE          = 0x0DF2;
static const int GL_SELECTION_BUFFER_POINTER      = 0x0DF3;
static const int GL_SELECTION_BUFFER_SIZE         = 0x0DF4;
/*      GL_TEXTURE_BINDING_1D */
/*      GL_TEXTURE_BINDING_2D */
/*      GL_VERTEX_ARRAY */
/*      GL_NORMAL_ARRAY */
/*      GL_COLOR_ARRAY */
/*      GL_INDEX_ARRAY */
/*      GL_TEXTURE_COORD_ARRAY */
/*      GL_EDGE_FLAG_ARRAY */
/*      GL_VERTEX_ARRAY_SIZE */
/*      GL_VERTEX_ARRAY_TYPE */
/*      GL_VERTEX_ARRAY_STRIDE */
/*      GL_NORMAL_ARRAY_TYPE */
/*      GL_NORMAL_ARRAY_STRIDE */
/*      GL_COLOR_ARRAY_SIZE */
/*      GL_COLOR_ARRAY_TYPE */
/*      GL_COLOR_ARRAY_STRIDE */
/*      GL_INDEX_ARRAY_TYPE */
/*      GL_INDEX_ARRAY_STRIDE */
/*      GL_TEXTURE_COORD_ARRAY_SIZE */
/*      GL_TEXTURE_COORD_ARRAY_TYPE */
/*      GL_TEXTURE_COORD_ARRAY_STRIDE */
/*      GL_EDGE_FLAG_ARRAY_STRIDE */
/*      GL_POLYGON_OFFSET_FACTOR */
/*      GL_POLYGON_OFFSET_UNITS */

/* GetTextureParameter */
/*      GL_TEXTURE_MAG_FILTER */
/*      GL_TEXTURE_MIN_FILTER */
/*      GL_TEXTURE_WRAP_S */
/*      GL_TEXTURE_WRAP_T */
static const int GL_TEXTURE_WIDTH                 = 0x1000;
static const int GL_TEXTURE_HEIGHT                = 0x1001;
static const int GL_TEXTURE_INTERNAL_FORMAT       = 0x1003;
static const int GL_TEXTURE_BORDER_COLOR          = 0x1004;
static const int GL_TEXTURE_BORDER                = 0x1005;
/*      GL_TEXTURE_RED_SIZE */
/*      GL_TEXTURE_GREEN_SIZE */
/*      GL_TEXTURE_BLUE_SIZE */
/*      GL_TEXTURE_ALPHA_SIZE */
/*      GL_TEXTURE_LUMINANCE_SIZE */
/*      GL_TEXTURE_INTENSITY_SIZE */
/*      GL_TEXTURE_PRIORITY */
/*      GL_TEXTURE_RESIDENT */

/* HintMode */
static const int GL_DONT_CARE                     = 0x1100;
static const int GL_FASTEST                       = 0x1101;
static const int GL_NICEST                        = 0x1102;

/* HintTarget */
/*      GL_PERSPECTIVE_CORRECTION_HINT */
/*      GL_POINT_SMOOTH_HINT */
/*      GL_LINE_SMOOTH_HINT */
/*      GL_POLYGON_SMOOTH_HINT */
/*      GL_FOG_HINT */
/*      GL_PHONG_HINT */

/* IndexPointerType */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* LightModelParameter */
/*      GL_LIGHT_MODEL_AMBIENT */
/*      GL_LIGHT_MODEL_LOCAL_VIEWER */
/*      GL_LIGHT_MODEL_TWO_SIDE */

/* LightName */
static const int GL_LIGHT0                        = 0x4000;
static const int GL_LIGHT1                        = 0x4001;
static const int GL_LIGHT2                        = 0x4002;
static const int GL_LIGHT3                        = 0x4003;
static const int GL_LIGHT4                        = 0x4004;
static const int GL_LIGHT5                        = 0x4005;
static const int GL_LIGHT6                        = 0x4006;
static const int GL_LIGHT7                        = 0x4007;

/* LightParameter */
static const int GL_AMBIENT                       = 0x1200;
static const int GL_DIFFUSE                       = 0x1201;
static const int GL_SPECULAR                      = 0x1202;
static const int GL_POSITION                      = 0x1203;
static const int GL_SPOT_DIRECTION                = 0x1204;
static const int GL_SPOT_EXPONENT                 = 0x1205;
static const int GL_SPOT_CUTOFF                   = 0x1206;
static const int GL_CONSTANT_ATTENUATION          = 0x1207;
static const int GL_LINEAR_ATTENUATION            = 0x1208;
static const int GL_QUADRATIC_ATTENUATION         = 0x1209;

/* InterleavedArrays */
/*      GL_V2F */
/*      GL_V3F */
/*      GL_C4UB_V2F */
/*      GL_C4UB_V3F */
/*      GL_C3F_V3F */
/*      GL_N3F_V3F */
/*      GL_C4F_N3F_V3F */
/*      GL_T2F_V3F */
/*      GL_T4F_V4F */
/*      GL_T2F_C4UB_V3F */
/*      GL_T2F_C3F_V3F */
/*      GL_T2F_N3F_V3F */
/*      GL_T2F_C4F_N3F_V3F */
/*      GL_T4F_C4F_N3F_V4F */

/* ListMode */
static const int GL_COMPILE                       = 0x1300;
static const int GL_COMPILE_AND_EXECUTE           = 0x1301;

/* ListNameType */
/*      GL_BYTE */
/*      GL_UNSIGNED_BYTE */
/*      GL_SHORT */
/*      GL_UNSIGNED_SHORT */
/*      GL_INT */
/*      GL_UNSIGNED_INT */
/*      GL_FLOAT */
/*      GL_2_BYTES */
/*      GL_3_BYTES */
/*      GL_4_BYTES */

/* LogicOp */
static const int GL_CLEAR                         = 0x1500;
static const int GL_AND                           = 0x1501;
static const int GL_AND_REVERSE                   = 0x1502;
static const int GL_COPY                          = 0x1503;
static const int GL_AND_INVERTED                  = 0x1504;
static const int GL_NOOP                          = 0x1505;
static const int GL_XOR                           = 0x1506;
static const int GL_OR                            = 0x1507;
static const int GL_NOR                           = 0x1508;
static const int GL_EQUIV                         = 0x1509;
static const int GL_INVERT                        = 0x150A;
static const int GL_OR_REVERSE                    = 0x150B;
static const int GL_COPY_INVERTED                 = 0x150C;
static const int GL_OR_INVERTED                   = 0x150D;
static const int GL_NAND                          = 0x150E;
static const int GL_SET                           = 0x150F;

/* MapTarget */
/*      GL_MAP1_COLOR_4 */
/*      GL_MAP1_INDEX */
/*      GL_MAP1_NORMAL */
/*      GL_MAP1_TEXTURE_COORD_1 */
/*      GL_MAP1_TEXTURE_COORD_2 */
/*      GL_MAP1_TEXTURE_COORD_3 */
/*      GL_MAP1_TEXTURE_COORD_4 */
/*      GL_MAP1_VERTEX_3 */
/*      GL_MAP1_VERTEX_4 */
/*      GL_MAP2_COLOR_4 */
/*      GL_MAP2_INDEX */
/*      GL_MAP2_NORMAL */
/*      GL_MAP2_TEXTURE_COORD_1 */
/*      GL_MAP2_TEXTURE_COORD_2 */
/*      GL_MAP2_TEXTURE_COORD_3 */
/*      GL_MAP2_TEXTURE_COORD_4 */
/*      GL_MAP2_VERTEX_3 */
/*      GL_MAP2_VERTEX_4 */

/* MaterialFace */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_FRONT_AND_BACK */

/* MaterialParameter */
static const int GL_EMISSION                      = 0x1600;
static const int GL_SHININESS                     = 0x1601;
static const int GL_AMBIENT_AND_DIFFUSE           = 0x1602;
static const int GL_COLOR_INDEXES                 = 0x1603;
/*      GL_AMBIENT */
/*      GL_DIFFUSE */
/*      GL_SPECULAR */

/* MatrixMode */
static const int GL_MODELVIEW                     = 0x1700;
static const int GL_PROJECTION                    = 0x1701;
static const int GL_TEXTURE                       = 0x1702;

/* MeshMode1 */
/*      GL_POINT */
/*      GL_LINE */

/* MeshMode2 */
/*      GL_POINT */
/*      GL_LINE */
/*      GL_FILL */

/* NormalPointerType */
/*      GL_BYTE */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* PixelCopyType */
static const int GL_COLOR                         = 0x1800;
static const int GL_DEPTH                         = 0x1801;
static const int GL_STENCIL                       = 0x1802;

/* PixelFormat */
static const int GL_COLOR_INDEX                   = 0x1900;
static const int GL_STENCIL_INDEX                 = 0x1901;
static const int GL_DEPTH_COMPONENT               = 0x1902;
static const int GL_RED                           = 0x1903;
static const int GL_GREEN                         = 0x1904;
static const int GL_BLUE                          = 0x1905;
static const int GL_ALPHA                         = 0x1906;
static const int GL_RGB                           = 0x1907;
static const int GL_RGBA                          = 0x1908;
static const int GL_LUMINANCE                     = 0x1909;
static const int GL_LUMINANCE_ALPHA               = 0x190A;

/* PixelMap */
/*      GL_PIXEL_MAP_I_TO_I */
/*      GL_PIXEL_MAP_S_TO_S */
/*      GL_PIXEL_MAP_I_TO_R */
/*      GL_PIXEL_MAP_I_TO_G */
/*      GL_PIXEL_MAP_I_TO_B */
/*      GL_PIXEL_MAP_I_TO_A */
/*      GL_PIXEL_MAP_R_TO_R */
/*      GL_PIXEL_MAP_G_TO_G */
/*      GL_PIXEL_MAP_B_TO_B */
/*      GL_PIXEL_MAP_A_TO_A */

/* PixelStore */
/*      GL_UNPACK_SWAP_BYTES */
/*      GL_UNPACK_LSB_FIRST */
/*      GL_UNPACK_ROW_LENGTH */
/*      GL_UNPACK_SKIP_ROWS */
/*      GL_UNPACK_SKIP_PIXELS */
/*      GL_UNPACK_ALIGNMENT */
/*      GL_PACK_SWAP_BYTES */
/*      GL_PACK_LSB_FIRST */
/*      GL_PACK_ROW_LENGTH */
/*      GL_PACK_SKIP_ROWS */
/*      GL_PACK_SKIP_PIXELS */
/*      GL_PACK_ALIGNMENT */

/* PixelTransfer */
/*      GL_MAP_COLOR */
/*      GL_MAP_STENCIL */
/*      GL_INDEX_SHIFT */
/*      GL_INDEX_OFFSET */
/*      GL_RED_SCALE */
/*      GL_RED_BIAS */
/*      GL_GREEN_SCALE */
/*      GL_GREEN_BIAS */
/*      GL_BLUE_SCALE */
/*      GL_BLUE_BIAS */
/*      GL_ALPHA_SCALE */
/*      GL_ALPHA_BIAS */
/*      GL_DEPTH_SCALE */
/*      GL_DEPTH_BIAS */

/* PixelType */
static const int GL_BITMAP                        = 0x1A00;
/*      GL_BYTE */
/*      GL_UNSIGNED_BYTE */
/*      GL_SHORT */
/*      GL_UNSIGNED_SHORT */
/*      GL_INT */
/*      GL_UNSIGNED_INT */
/*      GL_FLOAT */

/* PolygonMode */
static const int GL_POINT                         = 0x1B00;
static const int GL_LINE                          = 0x1B01;
static const int GL_FILL                          = 0x1B02;

/* ReadBufferMode */
/*      GL_FRONT_LEFT */
/*      GL_FRONT_RIGHT */
/*      GL_BACK_LEFT */
/*      GL_BACK_RIGHT */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_LEFT */
/*      GL_RIGHT */
/*      GL_AUX0 */
/*      GL_AUX1 */
/*      GL_AUX2 */
/*      GL_AUX3 */

/* RenderingMode */
static const int GL_RENDER                        = 0x1C00;
static const int GL_FEEDBACK                      = 0x1C01;
static const int GL_SELECT                        = 0x1C02;

/* ShadingModel */
static const int GL_FLAT                          = 0x1D00;
static const int GL_SMOOTH                        = 0x1D01;


/* StencilFunction */
/*      GL_NEVER */
/*      GL_LESS */
/*      GL_EQUAL */
/*      GL_LEQUAL */
/*      GL_GREATER */
/*      GL_NOTEQUAL */
/*      GL_GEQUAL */
/*      GL_ALWAYS */

/* StencilOp */
/*      GL_ZERO */
static const int GL_KEEP                          = 0x1E00;
static const int GL_REPLACE                       = 0x1E01;
static const int GL_INCR                          = 0x1E02;
static const int GL_DECR                          = 0x1E03;
/*      GL_INVERT */

/* StringName */
static const int GL_VENDOR                        = 0x1F00;
static const int GL_RENDERER                      = 0x1F01;
static const int GL_VERSION                       = 0x1F02;
static const int GL_EXTENSIONS                    = 0x1F03;

/* TextureCoordName */
static const int GL_S                             = 0x2000;
static const int GL_T                             = 0x2001;
static const int GL_R                             = 0x2002;
static const int GL_Q                             = 0x2003;

/* TexCoordPointerType */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* TextureEnvMode */
static const int GL_MODULATE                      = 0x2100;
static const int GL_DECAL                         = 0x2101;
/*      GL_BLEND */
/*      GL_REPLACE */

/* TextureEnvParameter */
static const int GL_TEXTURE_ENV_MODE              = 0x2200;
static const int GL_TEXTURE_ENV_COLOR             = 0x2201;

/* TextureEnvTarget */
static const int GL_TEXTURE_ENV                   = 0x2300;

/* TextureGenMode */
static const int GL_EYE_LINEAR                    = 0x2400;
static const int GL_OBJECT_LINEAR                 = 0x2401;
static const int GL_SPHERE_MAP                    = 0x2402;

/* TextureGenParameter */
static const int GL_TEXTURE_GEN_MODE              = 0x2500;
static const int GL_OBJECT_PLANE                  = 0x2501;
static const int GL_EYE_PLANE                     = 0x2502;

/* TextureMagFilter */
static const int GL_NEAREST                       = 0x2600;
static const int GL_LINEAR                        = 0x2601;

/* TextureMinFilter */
/*      GL_NEAREST */
/*      GL_LINEAR */
static const int GL_NEAREST_MIPMAP_NEAREST        = 0x2700;
static const int GL_LINEAR_MIPMAP_NEAREST         = 0x2701;
static const int GL_NEAREST_MIPMAP_LINEAR         = 0x2702;
static const int GL_LINEAR_MIPMAP_LINEAR          = 0x2703;

/* TextureParameterName */
static const int GL_TEXTURE_MAG_FILTER            = 0x2800;
static const int GL_TEXTURE_MIN_FILTER            = 0x2801;
static const int GL_TEXTURE_WRAP_S                = 0x2802;
static const int GL_TEXTURE_WRAP_T                = 0x2803;
/*      GL_TEXTURE_BORDER_COLOR */
/*      GL_TEXTURE_PRIORITY */

/* TextureTarget */
/*      GL_TEXTURE_1D */
/*      GL_TEXTURE_2D */
/*      GL_PROXY_TEXTURE_1D */
/*      GL_PROXY_TEXTURE_2D */

/* TextureWrapMode */
static const int GL_CLAMP                         = 0x2900;
static const int GL_REPEAT                        = 0x2901;

/* VertexPointerType */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* ClientAttribMask */
static const int GL_CLIENT_PIXEL_STORE_BIT        = 0x00000001;
static const int GL_CLIENT_VERTEX_ARRAY_BIT       = 0x00000002;
static const int GL_CLIENT_ALL_ATTRIB_BITS        = 0xfffffffF;

/* polygon_offset */
static const int GL_POLYGON_OFFSET_FACTOR         = 0x8038;
static const int GL_POLYGON_OFFSET_UNITS          = 0x2A00;
static const int GL_POLYGON_OFFSET_POINT          = 0x2A01;
static const int GL_POLYGON_OFFSET_LINE           = 0x2A02;
static const int GL_POLYGON_OFFSET_FILL           = 0x8037;

/* texture */
static const int GL_ALPHA4                        = 0x803B;
static const int GL_ALPHA8                        = 0x803C;
static const int GL_ALPHA12                       = 0x803D;
static const int GL_ALPHA16                       = 0x803E;
static const int GL_LUMINANCE4                    = 0x803F;
static const int GL_LUMINANCE8                    = 0x8040;
static const int GL_LUMINANCE12                   = 0x8041;
static const int GL_LUMINANCE16                   = 0x8042;
static const int GL_LUMINANCE4_ALPHA4             = 0x8043;
static const int GL_LUMINANCE6_ALPHA2             = 0x8044;
static const int GL_LUMINANCE8_ALPHA8             = 0x8045;
static const int GL_LUMINANCE12_ALPHA4            = 0x8046;
static const int GL_LUMINANCE12_ALPHA12           = 0x8047;
static const int GL_LUMINANCE16_ALPHA16           = 0x8048;
static const int GL_INTENSITY                     = 0x8049;
static const int GL_INTENSITY4                    = 0x804A;
static const int GL_INTENSITY8                    = 0x804B;
static const int GL_INTENSITY12                   = 0x804C;
static const int GL_INTENSITY16                   = 0x804D;
static const int GL_R3_G3_B2                      = 0x2A10;
static const int GL_RGB4                          = 0x804F;
static const int GL_RGB5                          = 0x8050;
static const int GL_RGB8                          = 0x8051;
static const int GL_RGB10                         = 0x8052;
static const int GL_RGB12                         = 0x8053;
static const int GL_RGB16                         = 0x8054;
static const int GL_RGBA2                         = 0x8055;
static const int GL_RGBA4                         = 0x8056;
static const int GL_RGB5_A1                       = 0x8057;
static const int GL_RGBA8                         = 0x8058;
static const int GL_RGB10_A2                      = 0x8059;
static const int GL_RGBA12                        = 0x805A;
static const int GL_RGBA16                        = 0x805B;
static const int GL_TEXTURE_RED_SIZE              = 0x805C;
static const int GL_TEXTURE_GREEN_SIZE            = 0x805D;
static const int GL_TEXTURE_BLUE_SIZE             = 0x805E;
static const int GL_TEXTURE_ALPHA_SIZE            = 0x805F;
static const int GL_TEXTURE_LUMINANCE_SIZE        = 0x8060;
static const int GL_TEXTURE_INTENSITY_SIZE        = 0x8061;
static const int GL_PROXY_TEXTURE_1D              = 0x8063;
static const int GL_PROXY_TEXTURE_2D              = 0x8064;

/* texture_object */
static const int GL_TEXTURE_PRIORITY              = 0x8066;
static const int GL_TEXTURE_RESIDENT              = 0x8067;
static const int GL_TEXTURE_BINDING_1D            = 0x8068;
static const int GL_TEXTURE_BINDING_2D            = 0x8069;

/* vertex_array */
static const int GL_VERTEX_ARRAY                  = 0x8074;
static const int GL_NORMAL_ARRAY                  = 0x8075;
static const int GL_COLOR_ARRAY                   = 0x8076;
static const int GL_INDEX_ARRAY                   = 0x8077;
static const int GL_TEXTURE_COORD_ARRAY           = 0x8078;
static const int GL_EDGE_FLAG_ARRAY               = 0x8079;
static const int GL_VERTEX_ARRAY_SIZE             = 0x807A;
static const int GL_VERTEX_ARRAY_TYPE             = 0x807B;
static const int GL_VERTEX_ARRAY_STRIDE           = 0x807C;
static const int GL_NORMAL_ARRAY_TYPE             = 0x807E;
static const int GL_NORMAL_ARRAY_STRIDE           = 0x807F;
static const int GL_COLOR_ARRAY_SIZE              = 0x8081;
static const int GL_COLOR_ARRAY_TYPE              = 0x8082;
static const int GL_COLOR_ARRAY_STRIDE            = 0x8083;
static const int GL_INDEX_ARRAY_TYPE              = 0x8085;
static const int GL_INDEX_ARRAY_STRIDE            = 0x8086;
static const int GL_TEXTURE_COORD_ARRAY_SIZE      = 0x8088;
static const int GL_TEXTURE_COORD_ARRAY_TYPE      = 0x8089;
static const int GL_TEXTURE_COORD_ARRAY_STRIDE    = 0x808A;
static const int GL_EDGE_FLAG_ARRAY_STRIDE        = 0x808C;
static const int GL_VERTEX_ARRAY_POINTER          = 0x808E;
static const int GL_NORMAL_ARRAY_POINTER          = 0x808F;
static const int GL_COLOR_ARRAY_POINTER           = 0x8090;
static const int GL_INDEX_ARRAY_POINTER           = 0x8091;
static const int GL_TEXTURE_COORD_ARRAY_POINTER   = 0x8092;
static const int GL_EDGE_FLAG_ARRAY_POINTER       = 0x8093;
static const int GL_V2F                           = 0x2A20;
static const int GL_V3F                           = 0x2A21;
static const int GL_C4UB_V2F                      = 0x2A22;
static const int GL_C4UB_V3F                      = 0x2A23;
static const int GL_C3F_V3F                       = 0x2A24;
static const int GL_N3F_V3F                       = 0x2A25;
static const int GL_C4F_N3F_V3F                   = 0x2A26;
static const int GL_T2F_V3F                       = 0x2A27;
static const int GL_T4F_V4F                       = 0x2A28;
static const int GL_T2F_C4UB_V3F                  = 0x2A29;
static const int GL_T2F_C3F_V3F                   = 0x2A2A;
static const int GL_T2F_N3F_V3F                   = 0x2A2B;
static const int GL_T2F_C4F_N3F_V3F               = 0x2A2C;
static const int GL_T4F_C4F_N3F_V4F               = 0x2A2D;

/* Extensions */
static const int GL_EXT_vertex_array              = 1;
static const int GL_EXT_bgra                      = 1;
static const int GL_EXT_paletted_texture          = 1;
static const int GL_WIN_swap_hint                 = 1;
static const int GL_WIN_draw_range_elements       = 1;
// static const int GL_WIN_phong_shading              1;
// static const int GL_WIN_specular_fog               1;

/* EXT_vertex_array */
static const int GL_VERTEX_ARRAY_EXT              = 0x8074;
static const int GL_NORMAL_ARRAY_EXT              = 0x8075;
static const int GL_COLOR_ARRAY_EXT               = 0x8076;
static const int GL_INDEX_ARRAY_EXT               = 0x8077;
static const int GL_TEXTURE_COORD_ARRAY_EXT       = 0x8078;
static const int GL_EDGE_FLAG_ARRAY_EXT           = 0x8079;
static const int GL_VERTEX_ARRAY_SIZE_EXT         = 0x807A;
static const int GL_VERTEX_ARRAY_TYPE_EXT         = 0x807B;
static const int GL_VERTEX_ARRAY_STRIDE_EXT       = 0x807C;
static const int GL_VERTEX_ARRAY_COUNT_EXT        = 0x807D;
static const int GL_NORMAL_ARRAY_TYPE_EXT         = 0x807E;
static const int GL_NORMAL_ARRAY_STRIDE_EXT       = 0x807F;
static const int GL_NORMAL_ARRAY_COUNT_EXT        = 0x8080;
static const int GL_COLOR_ARRAY_SIZE_EXT          = 0x8081;
static const int GL_COLOR_ARRAY_TYPE_EXT          = 0x8082;
static const int GL_COLOR_ARRAY_STRIDE_EXT        = 0x8083;
static const int GL_COLOR_ARRAY_COUNT_EXT         = 0x8084;
static const int GL_INDEX_ARRAY_TYPE_EXT          = 0x8085;
static const int GL_INDEX_ARRAY_STRIDE_EXT        = 0x8086;
static const int GL_INDEX_ARRAY_COUNT_EXT         = 0x8087;
static const int GL_TEXTURE_COORD_ARRAY_SIZE_EXT  = 0x8088;
static const int GL_TEXTURE_COORD_ARRAY_TYPE_EXT  = 0x8089;
static const int GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = 0x808A;
static const int GL_TEXTURE_COORD_ARRAY_COUNT_EXT = 0x808B;
static const int GL_EDGE_FLAG_ARRAY_STRIDE_EXT    = 0x808C;
static const int GL_EDGE_FLAG_ARRAY_COUNT_EXT     = 0x808D;
static const int GL_VERTEX_ARRAY_POINTER_EXT      = 0x808E;
static const int GL_NORMAL_ARRAY_POINTER_EXT      = 0x808F;
static const int GL_COLOR_ARRAY_POINTER_EXT       = 0x8090;
static const int GL_INDEX_ARRAY_POINTER_EXT       = 0x8091;
static const int GL_TEXTURE_COORD_ARRAY_POINTER_EXT = 0x8092;
static const int GL_EDGE_FLAG_ARRAY_POINTER_EXT   = 0x8093;
static const int GL_DOUBLE_EXT                    = GL_DOUBLE;

/* EXT_bgra */
static const int GL_BGR_EXT                       = 0x80E0;
static const int GL_BGRA_EXT                      = 0x80E1;

/* EXT_paletted_texture */

/* These must match the GL_COLOR_TABLE_*_SGI enumerants */
static const int GL_COLOR_TABLE_FORMAT_EXT        = 0x80D8;
static const int GL_COLOR_TABLE_WIDTH_EXT         = 0x80D9;
static const int GL_COLOR_TABLE_RED_SIZE_EXT      = 0x80DA;
static const int GL_COLOR_TABLE_GREEN_SIZE_EXT    = 0x80DB;
static const int GL_COLOR_TABLE_BLUE_SIZE_EXT     = 0x80DC;
static const int GL_COLOR_TABLE_ALPHA_SIZE_EXT    = 0x80DD;
static const int GL_COLOR_TABLE_LUMINANCE_SIZE_EXT = 0x80DE;
static const int GL_COLOR_TABLE_INTENSITY_SIZE_EXT = 0x80DF;

static const int GL_COLOR_INDEX1_EXT              = 0x80E2;
static const int GL_COLOR_INDEX2_EXT              = 0x80E3;
static const int GL_COLOR_INDEX4_EXT              = 0x80E4;
static const int GL_COLOR_INDEX8_EXT              = 0x80E5;
static const int GL_COLOR_INDEX12_EXT             = 0x80E6;
static const int GL_COLOR_INDEX16_EXT             = 0x80E7;

/* WIN_draw_range_elements */
static const int GL_MAX_ELEMENTS_VERTICES_WIN     = 0x80E8;
static const int GL_MAX_ELEMENTS_INDICES_WIN      = 0x80E9;

/* WIN_phong_shading */
static const int GL_PHONG_WIN                     = 0x80EA;
static const int GL_PHONG_HINT_WIN                = 0x80EB;

/* WIN_specular_fog */
static const int GL_FOG_SPECULAR_TEXTURE_WIN      = 0x80EC;

/* For compatibility with OpenGL v1.0 */
static const int GL_LOGIC_OP = GL_INDEX_LOGIC_OP;
static const int GL_TEXTURE_COMPONENTS = GL_TEXTURE_INTERNAL_FORMAT;
]]

-- Basic OpenGL interfacE;
ffi.cdef[[
/*************************************************************/

void glAccum (GLenum op, GLfloat value);
void glAlphaFunc (GLenum func, GLclampf ref);
GLboolean glAreTexturesResident (GLsizei n, const GLuint *textures, GLboolean *residences);
void glArrayElement (GLint i);
void glBegin (GLenum mode);
void glBindTexture (GLenum target, GLuint texture);
void glBitmap (GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, const GLubyte *bitmap);
void glBlendFunc (GLenum sfactor, GLenum dfactor);
void glCallList (GLuint list);
void glCallLists (GLsizei n, GLenum type, const GLvoid *lists);
void glClear (GLbitfield mask);
void glClearAccum (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void glClearColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
void glClearDepth (GLclampd depth);
void glClearIndex (GLfloat c);
void glClearStencil (GLint s);
void glClipPlane (GLenum plane, const GLdouble *equation);
void glColor3b (GLbyte red, GLbyte green, GLbyte blue);
void glColor3bv (const GLbyte *v);
void glColor3d (GLdouble red, GLdouble green, GLdouble blue);
void glColor3dv (const GLdouble *v);
void glColor3f (GLfloat red, GLfloat green, GLfloat blue);
void glColor3fv (const GLfloat *v);
void glColor3i (GLint red, GLint green, GLint blue);
void glColor3iv (const GLint *v);
void glColor3s (GLshort red, GLshort green, GLshort blue);
void glColor3sv (const GLshort *v);
void glColor3ub (GLubyte red, GLubyte green, GLubyte blue);
void glColor3ubv (const GLubyte *v);
void glColor3ui (GLuint red, GLuint green, GLuint blue);
void glColor3uiv (const GLuint *v);
void glColor3us (GLushort red, GLushort green, GLushort blue);
void glColor3usv (const GLushort *v);
void glColor4b (GLbyte red, GLbyte green, GLbyte blue, GLbyte alpha);
void glColor4bv (const GLbyte *v);
void glColor4d (GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha);
void glColor4dv (const GLdouble *v);
void glColor4f (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void glColor4fv (const GLfloat *v);
void glColor4i (GLint red, GLint green, GLint blue, GLint alpha);
void glColor4iv (const GLint *v);
void glColor4s (GLshort red, GLshort green, GLshort blue, GLshort alpha);
void glColor4sv (const GLshort *v);
void glColor4ub (GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha);
void glColor4ubv (const GLubyte *v);
void glColor4ui (GLuint red, GLuint green, GLuint blue, GLuint alpha);
void glColor4uiv (const GLuint *v);
void glColor4us (GLushort red, GLushort green, GLushort blue, GLushort alpha);
void glColor4usv (const GLushort *v);
void glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
void glColorMaterial (GLenum face, GLenum mode);
void glColorPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glCopyPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum type);
void glCopyTexImage1D (GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLint border);
void glCopyTexImage2D (GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
void glCopyTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
void glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
void glCullFace (GLenum mode);
void glDeleteLists (GLuint list, GLsizei range);
void glDeleteTextures (GLsizei n, const GLuint *textures);
void glDepthFunc (GLenum func);
void glDepthMask (GLboolean flag);
void glDepthRange (GLclampd zNear, GLclampd zFar);
void glDisable (GLenum cap);
void glDisableClientState (GLenum array);
void glDrawArrays (GLenum mode, GLint first, GLsizei count);
void glDrawBuffer (GLenum mode);
void glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
void glDrawPixels (GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void glEdgeFlag (GLboolean flag);
void glEdgeFlagPointer (GLsizei stride, const GLvoid *pointer);
void glEdgeFlagv (const GLboolean *flag);
void glEnable (GLenum cap);
void glEnableClientState (GLenum array);
void glEnd (void);
void glEndList (void);
void glEvalCoord1d (GLdouble u);
void glEvalCoord1dv (const GLdouble *u);
void glEvalCoord1f (GLfloat u);
void glEvalCoord1fv (const GLfloat *u);
void glEvalCoord2d (GLdouble u, GLdouble v);
void glEvalCoord2dv (const GLdouble *u);
void glEvalCoord2f (GLfloat u, GLfloat v);
void glEvalCoord2fv (const GLfloat *u);
void glEvalMesh1 (GLenum mode, GLint i1, GLint i2);
void glEvalMesh2 (GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2);
void glEvalPoint1 (GLint i);
void glEvalPoint2 (GLint i, GLint j);
void glFeedbackBuffer (GLsizei size, GLenum type, GLfloat *buffer);
void glFinish (void);
void glFlush (void);
void glFogf (GLenum pname, GLfloat param);
void glFogfv (GLenum pname, const GLfloat *params);
void glFogi (GLenum pname, GLint param);
void glFogiv (GLenum pname, const GLint *params);
void glFrontFace (GLenum mode);
void glFrustum (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
GLuint glGenLists (GLsizei range);
void glGenTextures (GLsizei n, GLuint *textures);
void glGetBooleanv (GLenum pname, GLboolean *params);
void glGetClipPlane (GLenum plane, GLdouble *equation);
void glGetDoublev (GLenum pname, GLdouble *params);
GLenum glGetError (void);
void glGetFloatv (GLenum pname, GLfloat *params);
void glGetIntegerv (GLenum pname, GLint *params);
void glGetLightfv (GLenum light, GLenum pname, GLfloat *params);
void glGetLightiv (GLenum light, GLenum pname, GLint *params);
void glGetMapdv (GLenum target, GLenum query, GLdouble *v);
void glGetMapfv (GLenum target, GLenum query, GLfloat *v);
void glGetMapiv (GLenum target, GLenum query, GLint *v);
void glGetMaterialfv (GLenum face, GLenum pname, GLfloat *params);
void glGetMaterialiv (GLenum face, GLenum pname, GLint *params);
void glGetPixelMapfv (GLenum map, GLfloat *values);
void glGetPixelMapuiv (GLenum map, GLuint *values);
void glGetPixelMapusv (GLenum map, GLushort *values);
void glGetPointerv (GLenum pname, GLvoid* *params);
void glGetPolygonStipple (GLubyte *mask);
const GLubyte * glGetString (GLenum name);
void glGetTexEnvfv (GLenum target, GLenum pname, GLfloat *params);
void glGetTexEnviv (GLenum target, GLenum pname, GLint *params);
void glGetTexGendv (GLenum coord, GLenum pname, GLdouble *params);
void glGetTexGenfv (GLenum coord, GLenum pname, GLfloat *params);
void glGetTexGeniv (GLenum coord, GLenum pname, GLint *params);
void glGetTexImage (GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
void glGetTexLevelParameterfv (GLenum target, GLint level, GLenum pname, GLfloat *params);
void glGetTexLevelParameteriv (GLenum target, GLint level, GLenum pname, GLint *params);
void glGetTexParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetTexParameteriv (GLenum target, GLenum pname, GLint *params);
void glHint (GLenum target, GLenum mode);
void glIndexMask (GLuint mask);
void glIndexPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void glIndexd (GLdouble c);
void glIndexdv (const GLdouble *c);
void glIndexf (GLfloat c);
void glIndexfv (const GLfloat *c);
void glIndexi (GLint c);
void glIndexiv (const GLint *c);
void glIndexs (GLshort c);
void glIndexsv (const GLshort *c);
void glIndexub (GLubyte c);
void glIndexubv (const GLubyte *c);
void glInitNames (void);
void glInterleavedArrays (GLenum format, GLsizei stride, const GLvoid *pointer);
GLboolean glIsEnabled (GLenum cap);
GLboolean glIsList (GLuint list);
GLboolean glIsTexture (GLuint texture);
void glLightModelf (GLenum pname, GLfloat param);
void glLightModelfv (GLenum pname, const GLfloat *params);
void glLightModeli (GLenum pname, GLint param);
void glLightModeliv (GLenum pname, const GLint *params);
void glLightf (GLenum light, GLenum pname, GLfloat param);
void glLightfv (GLenum light, GLenum pname, const GLfloat *params);
void glLighti (GLenum light, GLenum pname, GLint param);
void glLightiv (GLenum light, GLenum pname, const GLint *params);
void glLineStipple (GLint factor, GLushort pattern);
void glLineWidth (GLfloat width);
void glListBase (GLuint base);
void glLoadIdentity (void);
void glLoadMatrixd (const GLdouble *m);
void glLoadMatrixf (const GLfloat *m);
void glLoadName (GLuint name);
void glLogicOp (GLenum opcode);
void glMap1d (GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points);
void glMap1f (GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points);
void glMap2d (GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points);
void glMap2f (GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points);
void glMapGrid1d (GLint un, GLdouble u1, GLdouble u2);
void glMapGrid1f (GLint un, GLfloat u1, GLfloat u2);
void glMapGrid2d (GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2);
void glMapGrid2f (GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2);
void glMaterialf (GLenum face, GLenum pname, GLfloat param);
void glMaterialfv (GLenum face, GLenum pname, const GLfloat *params);
void glMateriali (GLenum face, GLenum pname, GLint param);
void glMaterialiv (GLenum face, GLenum pname, const GLint *params);
void glMatrixMode (GLenum mode);
void glMultMatrixd (const GLdouble *m);
void glMultMatrixf (const GLfloat *m);
void glNewList (GLuint list, GLenum mode);
void glNormal3b (GLbyte nx, GLbyte ny, GLbyte nz);
void glNormal3bv (const GLbyte *v);
void glNormal3d (GLdouble nx, GLdouble ny, GLdouble nz);
void glNormal3dv (const GLdouble *v);
void glNormal3f (GLfloat nx, GLfloat ny, GLfloat nz);
void glNormal3fv (const GLfloat *v);
void glNormal3i (GLint nx, GLint ny, GLint nz);
void glNormal3iv (const GLint *v);
void glNormal3s (GLshort nx, GLshort ny, GLshort nz);
void glNormal3sv (const GLshort *v);
void glNormalPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void glOrtho (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
void glPassThrough (GLfloat token);
void glPixelMapfv (GLenum map, GLsizei mapsize, const GLfloat *values);
void glPixelMapuiv (GLenum map, GLsizei mapsize, const GLuint *values);
void glPixelMapusv (GLenum map, GLsizei mapsize, const GLushort *values);
void glPixelStoref (GLenum pname, GLfloat param);
void glPixelStorei (GLenum pname, GLint param);
void glPixelTransferf (GLenum pname, GLfloat param);
void glPixelTransferi (GLenum pname, GLint param);
void glPixelZoom (GLfloat xfactor, GLfloat yfactor);
void glPointSize (GLfloat size);
void glPolygonMode (GLenum face, GLenum mode);
void glPolygonOffset (GLfloat factor, GLfloat units);
void glPolygonStipple (const GLubyte *mask);
void glPopAttrib (void);
void glPopClientAttrib (void);
void glPopMatrix (void);
void glPopName (void);
void glPrioritizeTextures (GLsizei n, const GLuint *textures, const GLclampf *priorities);
void glPushAttrib (GLbitfield mask);
void glPushClientAttrib (GLbitfield mask);
void glPushMatrix (void);
void glPushName (GLuint name);
void glRasterPos2d (GLdouble x, GLdouble y);
void glRasterPos2dv (const GLdouble *v);
void glRasterPos2f (GLfloat x, GLfloat y);
void glRasterPos2fv (const GLfloat *v);
void glRasterPos2i (GLint x, GLint y);
void glRasterPos2iv (const GLint *v);
void glRasterPos2s (GLshort x, GLshort y);
void glRasterPos2sv (const GLshort *v);
void glRasterPos3d (GLdouble x, GLdouble y, GLdouble z);
void glRasterPos3dv (const GLdouble *v);
void glRasterPos3f (GLfloat x, GLfloat y, GLfloat z);
void glRasterPos3fv (const GLfloat *v);
void glRasterPos3i (GLint x, GLint y, GLint z);
void glRasterPos3iv (const GLint *v);
void glRasterPos3s (GLshort x, GLshort y, GLshort z);
void glRasterPos3sv (const GLshort *v);
void glRasterPos4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glRasterPos4dv (const GLdouble *v);
void glRasterPos4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void glRasterPos4fv (const GLfloat *v);
void glRasterPos4i (GLint x, GLint y, GLint z, GLint w);
void glRasterPos4iv (const GLint *v);
void glRasterPos4s (GLshort x, GLshort y, GLshort z, GLshort w);
void glRasterPos4sv (const GLshort *v);
void glReadBuffer (GLenum mode);
void glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void glRectd (GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2);
void glRectdv (const GLdouble *v1, const GLdouble *v2);
void glRectf (GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2);
void glRectfv (const GLfloat *v1, const GLfloat *v2);
void glRecti (GLint x1, GLint y1, GLint x2, GLint y2);
void glRectiv (const GLint *v1, const GLint *v2);
void glRects (GLshort x1, GLshort y1, GLshort x2, GLshort y2);
void glRectsv (const GLshort *v1, const GLshort *v2);
GLint glRenderMode (GLenum mode);
void glRotated (GLdouble angle, GLdouble x, GLdouble y, GLdouble z);
void glRotatef (GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
void glScaled (GLdouble x, GLdouble y, GLdouble z);
void glScalef (GLfloat x, GLfloat y, GLfloat z);
void glScissor (GLint x, GLint y, GLsizei width, GLsizei height);
void glSelectBuffer (GLsizei size, GLuint *buffer);
void glShadeModel (GLenum mode);
void glStencilFunc (GLenum func, GLint ref, GLuint mask);
void glStencilMask (GLuint mask);
void glStencilOp (GLenum fail, GLenum zfail, GLenum zpass);
void glTexCoord1d (GLdouble s);
void glTexCoord1dv (const GLdouble *v);
void glTexCoord1f (GLfloat s);
void glTexCoord1fv (const GLfloat *v);
void glTexCoord1i (GLint s);
void glTexCoord1iv (const GLint *v);
void glTexCoord1s (GLshort s);
void glTexCoord1sv (const GLshort *v);
void glTexCoord2d (GLdouble s, GLdouble t);
void glTexCoord2dv (const GLdouble *v);
void glTexCoord2f (GLfloat s, GLfloat t);
void glTexCoord2fv (const GLfloat *v);
void glTexCoord2i (GLint s, GLint t);
void glTexCoord2iv (const GLint *v);
void glTexCoord2s (GLshort s, GLshort t);
void glTexCoord2sv (const GLshort *v);
void glTexCoord3d (GLdouble s, GLdouble t, GLdouble r);
void glTexCoord3dv (const GLdouble *v);
void glTexCoord3f (GLfloat s, GLfloat t, GLfloat r);
void glTexCoord3fv (const GLfloat *v);
void glTexCoord3i (GLint s, GLint t, GLint r);
void glTexCoord3iv (const GLint *v);
void glTexCoord3s (GLshort s, GLshort t, GLshort r);
void glTexCoord3sv (const GLshort *v);
void glTexCoord4d (GLdouble s, GLdouble t, GLdouble r, GLdouble q);
void glTexCoord4dv (const GLdouble *v);
void glTexCoord4f (GLfloat s, GLfloat t, GLfloat r, GLfloat q);
void glTexCoord4fv (const GLfloat *v);
void glTexCoord4i (GLint s, GLint t, GLint r, GLint q);
void glTexCoord4iv (const GLint *v);
void glTexCoord4s (GLshort s, GLshort t, GLshort r, GLshort q);
void glTexCoord4sv (const GLshort *v);
void glTexCoordPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glTexEnvf (GLenum target, GLenum pname, GLfloat param);
void glTexEnvfv (GLenum target, GLenum pname, const GLfloat *params);
void glTexEnvi (GLenum target, GLenum pname, GLint param);
void glTexEnviv (GLenum target, GLenum pname, const GLint *params);
void glTexGend (GLenum coord, GLenum pname, GLdouble param);
void glTexGendv (GLenum coord, GLenum pname, const GLdouble *params);
void glTexGenf (GLenum coord, GLenum pname, GLfloat param);
void glTexGenfv (GLenum coord, GLenum pname, const GLfloat *params);
void glTexGeni (GLenum coord, GLenum pname, GLint param);
void glTexGeniv (GLenum coord, GLenum pname, const GLint *params);
void glTexImage1D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexParameterf (GLenum target, GLenum pname, GLfloat param);
void glTexParameterfv (GLenum target, GLenum pname, const GLfloat *params);
void glTexParameteri (GLenum target, GLenum pname, GLint param);
void glTexParameteriv (GLenum target, GLenum pname, const GLint *params);
void glTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
void glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void glTranslated (GLdouble x, GLdouble y, GLdouble z);
void glTranslatef (GLfloat x, GLfloat y, GLfloat z);
void glVertex2d (GLdouble x, GLdouble y);
void glVertex2dv (const GLdouble *v);
void glVertex2f (GLfloat x, GLfloat y);
void glVertex2fv (const GLfloat *v);
void glVertex2i (GLint x, GLint y);
void glVertex2iv (const GLint *v);
void glVertex2s (GLshort x, GLshort y);
void glVertex2sv (const GLshort *v);
void glVertex3d (GLdouble x, GLdouble y, GLdouble z);
void glVertex3dv (const GLdouble *v);
void glVertex3f (GLfloat x, GLfloat y, GLfloat z);
void glVertex3fv (const GLfloat *v);
void glVertex3i (GLint x, GLint y, GLint z);
void glVertex3iv (const GLint *v);
void glVertex3s (GLshort x, GLshort y, GLshort z);
void glVertex3sv (const GLshort *v);
void glVertex4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glVertex4dv (const GLdouble *v);
void glVertex4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void glVertex4fv (const GLfloat *v);
void glVertex4i (GLint x, GLint y, GLint z, GLint w);
void glVertex4iv (const GLint *v);
void glVertex4s (GLshort x, GLshort y, GLshort z, GLshort w);
void glVertex4sv (const GLshort *v);
void glVertexPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glViewport (GLint x, GLint y, GLsizei width, GLsizei height);
]]

ffi.cdef[[
/* EXT_vertex_array */
typedef void (* PFNGLARRAYELEMENTEXTPROC) (GLint i);
typedef void (* PFNGLDRAWARRAYSEXTPROC) (GLenum mode, GLint first, GLsizei count);
typedef void (* PFNGLVERTEXPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void (* PFNGLNORMALPOINTEREXTPROC) (GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void (* PFNGLCOLORPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void (* PFNGLINDEXPOINTEREXTPROC) (GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void (* PFNGLTEXCOORDPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, const GLvoid *pointer);
typedef void (* PFNGLEDGEFLAGPOINTEREXTPROC) (GLsizei stride, GLsizei count, const GLboolean *pointer);
typedef void (* PFNGLGETPOINTERVEXTPROC) (GLenum pname, GLvoid* *params);
typedef void (* PFNGLARRAYELEMENTARRAYEXTPROC)(GLenum mode, GLsizei count, const GLvoid* pi);
]]

ffi.cdef[[
/* WIN_draw_range_elements */
typedef void (* PFNGLDRAWRANGEELEMENTSWINPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices);

/* WIN_swap_hint */
typedef void (* PFNGLADDSWAPHINTRECTWINPROC)  (GLint x, GLint y, GLsizei width, GLsizei height);

/* EXT_paletted_texture */
typedef void (* PFNGLCOLORTABLEEXTPROC)
    (GLenum target, GLenum internalFormat, GLsizei width, GLenum format,
     GLenum type, const GLvoid *data);
typedef void (* PFNGLCOLORSUBTABLEEXTPROC)
    (GLenum target, GLsizei start, GLsizei count, GLenum format,
     GLenum type, const GLvoid *data);
typedef void (* PFNGLGETCOLORTABLEEXTPROC)
    (GLenum target, GLenum format, GLenum type, GLvoid *data);
typedef void (* PFNGLGETCOLORTABLEPARAMETERIVEXTPROC)
    (GLenum target, GLenum pname, GLint *params);
typedef void (* PFNGLGETCOLORTABLEPARAMETERFVEXTPROC)
    (GLenum target, GLenum pname, GLfloat *params);

]]

local glLib = ffi.load("opengl32")

return glLib;

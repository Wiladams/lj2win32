local ffi = require("ffi")


require("win32.gl.gl")


local exports = {}

ffi.cdef[[
const GLubyte* gluErrorString (
    GLenum   errCode);

const wchar_t* gluErrorUnicodeStringEXT (
    GLenum   errCode);

const GLubyte* gluGetString (
    GLenum   name);
]]

--[[
if UNICODE then
static const int gluErrorStringWIN(errCode) ((LPCSTR)  gluErrorUnicodeStringEXT(errCode))
else
static const int gluErrorStringWIN(errCode) ((LPCWSTR) gluErrorString(errCode))
end
--]]


ffi.cdef[[
void gluOrtho2D (
    GLdouble left, 
    GLdouble right, 
    GLdouble bottom, 
    GLdouble top);

void gluPerspective (
    GLdouble fovy, 
    GLdouble aspect, 
    GLdouble zNear, 
    GLdouble zFar);

void gluPickMatrix (
    GLdouble x, 
    GLdouble y, 
    GLdouble width, 
    GLdouble height, 
    GLint    viewport[4]);

void gluLookAt (
    GLdouble eyex, 
    GLdouble eyey, 
    GLdouble eyez, 
    GLdouble centerx, 
    GLdouble centery, 
    GLdouble centerz, 
    GLdouble upx, 
    GLdouble upy, 
    GLdouble upz);

int gluProject (
    GLdouble        objx, 
    GLdouble        objy, 
    GLdouble        objz,  
    const GLdouble  modelMatrix[16], 
    const GLdouble  projMatrix[16], 
    const GLint     viewport[4], 
    GLdouble        *winx, 
    GLdouble        *winy, 
    GLdouble        *winz);

int gluUnProject (
    GLdouble       winx, 
    GLdouble       winy, 
    GLdouble       winz, 
    const GLdouble modelMatrix[16], 
    const GLdouble projMatrix[16], 
    const GLint    viewport[4], 
    GLdouble       *objx, 
    GLdouble       *objy, 
    GLdouble       *objz);


int gluScaleImage (
    GLenum      format, 
    GLint       widthin, 
    GLint       heightin, 
    GLenum      typein, 
    const void  *datain, 
    GLint       widthout, 
    GLint       heightout, 
    GLenum      typeout, 
    void        *dataout);


int gluBuild1DMipmaps (
    GLenum      target, 
    GLint       components, 
    GLint       width, 
    GLenum      format, 
    GLenum      type, 
    const void  *data);

int gluBuild2DMipmaps (
    GLenum      target, 
    GLint       components, 
    GLint       width, 
    GLint       height, 
    GLenum      format, 
    GLenum      type, 
    const void  *data);
]]

--[[
#ifdef __cplusplus

class GLUnurbs;
class GLUquadric;
class GLUtesselator;

/* backwards compatibility: */
typedef class GLUnurbs GLUnurbsObj;
typedef class GLUquadric GLUquadricObj;
typedef class GLUtesselator GLUtesselatorObj;
typedef class GLUtesselator GLUtriangulatorObj;

#else
--]]

ffi.cdef[[
typedef struct GLUnurbs GLUnurbs;
typedef struct GLUquadric GLUquadric;
typedef struct GLUtesselator GLUtesselator;

/* backwards compatibility: */
typedef struct GLUnurbs GLUnurbsObj;
typedef struct GLUquadric GLUquadricObj;
typedef struct GLUtesselator GLUtesselatorObj;
typedef struct GLUtesselator GLUtriangulatorObj;
]]

ffi.cdef[[
GLUquadric* gluNewQuadric (void);
void gluDeleteQuadric (
    GLUquadric          *state);

void gluQuadricNormals (
    GLUquadric          *quadObject, 
    GLenum              normals);

void gluQuadricTexture (
    GLUquadric          *quadObject, 
    GLboolean           textureCoords);

void gluQuadricOrientation (
    GLUquadric          *quadObject, 
    GLenum              orientation);

void gluQuadricDrawStyle (
    GLUquadric          *quadObject, 
    GLenum              drawStyle);

void gluCylinder (
    GLUquadric          *qobj, 
    GLdouble            baseRadius, 
    GLdouble            topRadius, 
    GLdouble            height, 
    GLint               slices, 
    GLint               stacks);

void gluDisk (
    GLUquadric          *qobj, 
    GLdouble            innerRadius, 
    GLdouble            outerRadius, 
    GLint               slices, 
    GLint               loops);

void gluPartialDisk (
    GLUquadric          *qobj, 
    GLdouble            innerRadius, 
    GLdouble            outerRadius, 
    GLint               slices, 
    GLint               loops, 
    GLdouble            startAngle, 
    GLdouble            sweepAngle);

void gluSphere (
    GLUquadric          *qobj, 
    GLdouble            radius, 
    GLint               slices, 
    GLint               stacks);

void gluQuadricCallback (
    GLUquadric          *qobj, 
    GLenum              which, 
    void                (__stdcall* fn)());

GLUtesselator*  gluNewTess(          
    void );

void  gluDeleteTess(       
    GLUtesselator       *tess );

void  gluTessBeginPolygon( 
    GLUtesselator       *tess,
    void                *polygon_data );

void  gluTessBeginContour( 
    GLUtesselator       *tess );

void  gluTessVertex(       
    GLUtesselator       *tess,
    GLdouble            coords[3], 
    void                *data );

void  gluTessEndContour(   
    GLUtesselator       *tess );

void  gluTessEndPolygon(   
    GLUtesselator       *tess );

void  gluTessProperty(     
    GLUtesselator       *tess,
    GLenum              which, 
    GLdouble            value );
 
void  gluTessNormal(       
    GLUtesselator       *tess, 
    GLdouble            x,
    GLdouble            y, 
    GLdouble            z );

void  gluTessCallback(     
    GLUtesselator       *tess,
    GLenum              which, 
    void                (__stdcall *fn)());

void  gluGetTessProperty(  
    GLUtesselator       *tess,
    GLenum              which, 
    GLdouble            *value );
 
GLUnurbs* gluNewNurbsRenderer (void);

void gluDeleteNurbsRenderer (
    GLUnurbs            *nobj);

void gluBeginSurface (
    GLUnurbs            *nobj);

void gluBeginCurve (
    GLUnurbs            *nobj);

void gluEndCurve (
    GLUnurbs            *nobj);

void gluEndSurface (
    GLUnurbs            *nobj);

void gluBeginTrim (
    GLUnurbs            *nobj);

void gluEndTrim (
    GLUnurbs            *nobj);

void gluPwlCurve (
    GLUnurbs            *nobj, 
    GLint               count, 
    GLfloat             *array, 
    GLint               stride, 
    GLenum              type);

void gluNurbsCurve (
    GLUnurbs            *nobj, 
    GLint               nknots, 
    GLfloat             *knot, 
    GLint               stride, 
    GLfloat             *ctlarray, 
    GLint               order, 
    GLenum              type);

void 
gluNurbsSurface(     
    GLUnurbs            *nobj, 
    GLint               sknot_count, 
    float               *sknot, 
    GLint               tknot_count, 
    GLfloat             *tknot, 
    GLint               s_stride, 
    GLint               t_stride, 
    GLfloat             *ctlarray, 
    GLint               sorder, 
    GLint               torder, 
    GLenum              type);

void 
gluLoadSamplingMatrices (
    GLUnurbs            *nobj, 
    const GLfloat       modelMatrix[16], 
    const GLfloat       projMatrix[16], 
    const GLint         viewport[4] );

void 
gluNurbsProperty (
    GLUnurbs            *nobj, 
    GLenum              property, 
    GLfloat             value );

void 
gluGetNurbsProperty (
    GLUnurbs            *nobj, 
    GLenum              property, 
    GLfloat             *value );

void 
gluNurbsCallback (
    GLUnurbs            *nobj, 
    GLenum              which, 
    void                (__stdcall* fn)() );
]]


ffi.cdef[[
/****           Callback function prototypes    ****/

/* gluQuadricCallback */
typedef void (__stdcall* GLUquadricErrorProc) (GLenum);

/* gluTessCallback */
typedef void (__stdcall* GLUtessBeginProc)        (GLenum);
typedef void (__stdcall* GLUtessEdgeFlagProc)     (GLboolean);
typedef void (__stdcall* GLUtessVertexProc)       (void *);
typedef void (__stdcall* GLUtessEndProc)          (void);
typedef void (__stdcall* GLUtessErrorProc)        (GLenum);
typedef void (__stdcall* GLUtessCombineProc)      (GLdouble[3],
                                                  void*[4], 
                                                  GLfloat[4],
                                                  void** );
typedef void (__stdcall* GLUtessBeginDataProc)    (GLenum, void *);
typedef void (__stdcall* GLUtessEdgeFlagDataProc) (GLboolean, void *);
typedef void (__stdcall* GLUtessVertexDataProc)   (void *, void *);
typedef void (__stdcall* GLUtessEndDataProc)      (void *);
typedef void (__stdcall* GLUtessErrorDataProc)    (GLenum, void *);
typedef void (__stdcall* GLUtessCombineDataProc)  (GLdouble[3],
                                                  void*[4], 
                                                  GLfloat[4],
                                                  void**,
                                                  void* );

/* gluNurbsCallback */
typedef void (__stdcall* GLUnurbsErrorProc)   (GLenum);
]]

ffi.cdef[[
/* Version */
static const int GLU_VERSION_1_1               =  1;
static const int GLU_VERSION_1_2               =  1;

/* Errors: (return value 0 = no error) */
static const int GLU_INVALID_ENUM      =  100900;
static const int GLU_INVALID_VALUE     =  100901;
static const int GLU_OUT_OF_MEMORY     =  100902;
static const int GLU_INCOMPATIBLE_GL_VERSION   =  100903;

/* StringName */
static const int GLU_VERSION            = 100800;
static const int GLU_EXTENSIONS         = 100801;

/* Boolean */
static const int GLU_TRUE               = GL_TRUE;
static const int GLU_FALSE              = GL_FALSE;
]]

ffi.cdef[[
/****           Quadric constants               ****/

/* QuadricNormal */
static const int GLU_SMOOTH             = 100000;
static const int GLU_FLAT               = 100001;
static const int GLU_NONE               = 100002;

/* QuadricDrawStyle */
static const int GLU_POINT              = 100010;
static const int GLU_LINE               = 100011;
static const int GLU_FILL               = 100012;
static const int GLU_SILHOUETTE         = 100013;

/* QuadricOrientation */
static const int GLU_OUTSIDE            = 100020;
static const int GLU_INSIDE             = 100021;

/* Callback types: */
/*      GLU_ERROR               100103 */
]]


--/****           Tesselation constants           ****/

exports.GLU_TESS_MAX_COORD = 1.0e150;

ffi.cdef[[
/* TessProperty */
static const int GLU_TESS_WINDING_RULE         =  100140;
static const int GLU_TESS_BOUNDARY_ONLY        =  100141;
static const int GLU_TESS_TOLERANCE            =  100142;

/* TessWinding */
static const int GLU_TESS_WINDING_ODD          =  100130;
static const int GLU_TESS_WINDING_NONZERO      =  100131;
static const int GLU_TESS_WINDING_POSITIVE     =  100132;
static const int GLU_TESS_WINDING_NEGATIVE     =  100133;
static const int GLU_TESS_WINDING_ABS_GEQ_TWO  =  100134;

/* TessCallback */
static const int GLU_TESS_BEGIN         = 100100;  /* void (__stdcall*)(GLenum    type)  */
static const int GLU_TESS_VERTEX        = 100101;  /* void (__stdcall*)(void      *data) */
static const int GLU_TESS_END           = 100102;  /* void (__stdcall*)(void)            */
static const int GLU_TESS_ERROR         = 100103;  /* void (__stdcall*)(GLenum    errno) */
static const int GLU_TESS_EDGE_FLAG     = 100104;  /* void (__stdcall*)(GLboolean boundaryEdge)  */
static const int GLU_TESS_COMBINE       = 100105;  /* void (__stdcall*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut)     */
static const int GLU_TESS_BEGIN_DATA    = 100106;  /* void (__stdcall*)(GLenum    type,  
                                                            void      *polygon_data) */
static const int GLU_TESS_VERTEX_DATA   = 100107;  /* void (__stdcall*)(void      *data, 
                                                            void      *polygon_data) */
static const int GLU_TESS_END_DATA      = 100108;  /* void (__stdcall*)(void      *polygon_data) */
static const int GLU_TESS_ERROR_DATA    = 100109;  /* void (__stdcall*)(GLenum    errno, 
                                                            void      *polygon_data) */
static const int GLU_TESS_EDGE_FLAG_DATA =100110;  /* void (__stdcall*)(GLboolean boundaryEdge,
                                                            void      *polygon_data) */
static const int GLU_TESS_COMBINE_DATA  = 100111;  /* void (__stdcall*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut,
                                                            void      *polygon_data) */

/* TessError */
static const int GLU_TESS_ERROR1    = 100151;
static const int GLU_TESS_ERROR2    = 100152;
static const int GLU_TESS_ERROR3    = 100153;
static const int GLU_TESS_ERROR4    = 100154;
static const int GLU_TESS_ERROR5    = 100155;
static const int GLU_TESS_ERROR6    = 100156;
static const int GLU_TESS_ERROR7    = 100157;
static const int GLU_TESS_ERROR8    = 100158;

static const int GLU_TESS_MISSING_BEGIN_POLYGON = GLU_TESS_ERROR1;
static const int GLU_TESS_MISSING_BEGIN_CONTOUR = GLU_TESS_ERROR2;
static const int GLU_TESS_MISSING_END_POLYGON   = GLU_TESS_ERROR3;
static const int GLU_TESS_MISSING_END_CONTOUR   = GLU_TESS_ERROR4;
static const int GLU_TESS_COORD_TOO_LARGE       = GLU_TESS_ERROR5;
static const int GLU_TESS_NEED_COMBINE_CALLBACK = GLU_TESS_ERROR6;
]]

ffi.cdef[[
/****           NURBS constants                 ****/

/* NurbsProperty */
static const int GLU_AUTO_LOAD_MATRIX   = 100200;
static const int GLU_CULLING            = 100201;
static const int GLU_SAMPLING_TOLERANCE = 100203;
static const int GLU_DISPLAY_MODE       = 100204;
static const int GLU_PARAMETRIC_TOLERANCE      =  100202;
static const int GLU_SAMPLING_METHOD           =  100205;
static const int GLU_U_STEP                    =  100206;
static const int GLU_V_STEP                    =  100207;

/* NurbsSampling */
static const int GLU_PATH_LENGTH               =  100215;
static const int GLU_PARAMETRIC_ERROR          =  100216;
static const int GLU_DOMAIN_DISTANCE           =  100217;


/* NurbsTrim */
static const int GLU_MAP1_TRIM_2        = 100210;
static const int GLU_MAP1_TRIM_3        = 100211;

/* NurbsDisplay */
/*      GLU_FILL                100012 */
static const int GLU_OUTLINE_POLYGON    = 100240;
static const int GLU_OUTLINE_PATCH      = 100241;

/* NurbsCallback */
/*      GLU_ERROR               100103 */

/* NurbsErrors */
static const int GLU_NURBS_ERROR1      =  100251;
static const int GLU_NURBS_ERROR2      =  100252;
static const int GLU_NURBS_ERROR3      =  100253;
static const int GLU_NURBS_ERROR4      =  100254;
static const int GLU_NURBS_ERROR5      =  100255;
static const int GLU_NURBS_ERROR6      =  100256;
static const int GLU_NURBS_ERROR7      =  100257;
static const int GLU_NURBS_ERROR8      =  100258;
static const int GLU_NURBS_ERROR9      =  100259;
static const int GLU_NURBS_ERROR10     =  100260;
static const int GLU_NURBS_ERROR11     =  100261;
static const int GLU_NURBS_ERROR12     =  100262;
static const int GLU_NURBS_ERROR13     =  100263;
static const int GLU_NURBS_ERROR14     =  100264;
static const int GLU_NURBS_ERROR15     =  100265;
static const int GLU_NURBS_ERROR16     =  100266;
static const int GLU_NURBS_ERROR17     =  100267;
static const int GLU_NURBS_ERROR18     =  100268;
static const int GLU_NURBS_ERROR19     =  100269;
static const int GLU_NURBS_ERROR20     =  100270;
static const int GLU_NURBS_ERROR21     =  100271;
static const int GLU_NURBS_ERROR22     =  100272;
static const int GLU_NURBS_ERROR23     =  100273;
static const int GLU_NURBS_ERROR24     =  100274;
static const int GLU_NURBS_ERROR25     =  100275;
static const int GLU_NURBS_ERROR26     =  100276;
static const int GLU_NURBS_ERROR27     =  100277;
static const int GLU_NURBS_ERROR28     =  100278;
static const int GLU_NURBS_ERROR29     =  100279;
static const int GLU_NURBS_ERROR30     =  100280;
static const int GLU_NURBS_ERROR31     =  100281;
static const int GLU_NURBS_ERROR32     =  100282;
static const int GLU_NURBS_ERROR33     =  100283;
static const int GLU_NURBS_ERROR34     =  100284;
static const int GLU_NURBS_ERROR35     =  100285;
static const int GLU_NURBS_ERROR36     =  100286;
static const int GLU_NURBS_ERROR37     =  100287;
]]

ffi.cdef[[
/****           Backwards compatibility for old tesselator           ****/

void   gluBeginPolygon( GLUtesselator *tess );

void   gluNextContour(  GLUtesselator *tess, 
                                 GLenum        type );

void   gluEndPolygon(   GLUtesselator *tess );
]]

--[[
/* Contours types -- obsolete! */
static const int GLU_CW         = 100120;
static const int GLU_CCW        = 100121;
static const int GLU_INTERIOR   = 100122;
static const int GLU_EXTERIOR   = 100123;
static const int GLU_UNKNOWN    = 100124;
--]]

ffi.cdef[[
/* Names without "TESS_" prefix */
static const int GLU_BEGIN      = GLU_TESS_BEGIN;
static const int GLU_VERTEX     = GLU_TESS_VERTEX;
static const int GLU_END        = GLU_TESS_END;
static const int GLU_ERROR      = GLU_TESS_ERROR;
static const int GLU_EDGE_FLAG  = GLU_TESS_EDGE_FLAG;
]]

return exports

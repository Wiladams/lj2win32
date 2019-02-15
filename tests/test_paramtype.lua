local ffi = require("ffi")

local PROPSHEETPAGEA_V1_FIELDS  =[[
    int           dwSize;        
    int           dwFlags;       
    void *       hInstance;     
    union                          
    {                              
        const char *      pszTemplate;   
        void * pResource; 
    } ;              
    union                          
    {                              
        void *        hIcon;        
        const char *       pszIcon;      
    } ;             
    const char *           pszTitle;     
    uintptr_t           lParam;       
    unsigned int             *pcRefParent; 
    ]]

ffi.typeof([[typedef struct _PROPSHEETPAGEA_V1 { $ } PROPSHEETPAGEA_V1]], PROPSHEETPAGEA_V1_FIELDS)

--[[
    typedef const PROPSHEETPAGEA_V1 *LPCPROPSHEETPAGEA_V1;
    
    typedef struct _PROPSHEETPAGEA_V2
    {
        $   //PROPSHEETPAGEA_V1_FIELDS
    
        const char *           pszHeaderTitle;    // this is displayed in the header
        const char *           pszHeaderSubTitle; //
    } PROPSHEETPAGEA_V2, *LPPROPSHEETPAGEA_V2;
    typedef const PROPSHEETPAGEA_V2 *LPCPROPSHEETPAGEA_V2;
, PROPSHEETPAGEA_V1_FIELDS)
--]]
--[[
    This file was originally written in C++.  It will read a .emf (Enhanced Metafile)

Origin    
https://www.companionsoftware.com/software/metafile-utilities/

/**************************************************************************/
/*                                                                        */
/*    File: listemf.cpp                                                   */
/*  Author: lmd                                                           */
/* Created: 11/08/95                                                      */
/*                                                                        */
/* Description: List out a textual representation of an enhanced          */
/*              metafile ( EMF file )                                     */
/*                                                                        */
/**************************************************************************/
]]

local ffi = require("ffi")
local bit = require("bit")
local emrcodec = require("EMRCodec")


// defines
local function ISBETWEEN( x, min, max ) return ( ( x  >= min  ) and ( x  <= max ) ) end

#define DIM( x ) ( sizeof( x ) / sizeof( x[0] ) )



local PeError_t = enum {
   [0] = "PEERROR_NO_ERROR",
   "PEERROR_FILE_NOT_FOUND",
   "PEERROR_NOT_AN_EMF_FILE",
   "PEERROR_INVALID_METAFILE_HEADER_TYPE",
   "PEERROR_READING_METAFILE_HEADER",
   "PEERROR_READING_METAFILE_RECORD",
   "PEERROR_ALLOCATING_MEMORY_FOR_RECORD",
};

local PEERROR_FIRST  = PeError_t.PEERROR_NO_ERROR;
local PEERROR_LAST   = PeError_t.PEERROR_ALLOCATING_MEMORY_FOR_RECORD;

local apszErrorMessage = enum   {
      [0] = "",
      "File not found.",
      "Expected an EMF file.",
      "Invalid metafile header type.",
      "Error reading metafile header.",
      "Error reading metafile record.",
      "Unable to allocate memory for the following record."
};

--[[
typedef struct {
   DWORD dwId;
   char *pszName;
} ID_NAME_PAIR, *PID_NAME_PAIR;
--]]

--[[
// command line parameters
char* g_pszFilespec = NULL;
BOOL  g_bPrintSize = TRUE;
BOOL  g_bPrintData = TRUE;
BOOL  g_bPrintLargeDataSets = TRUE;
BOOL  g_bPrintHeaders = TRUE;
BOOL  g_bPrintFile = TRUE;
BOOL  g_bPrintRecords = TRUE;
BOOL  g_bPrintDescription = TRUE;

BOOL  g_bCheckMetafileHeaderRecord;

void main( int, char *[] );
BOOL ProcessArguments( int argc, char *argv[] );
local function error( int nError );
static BOOL ProcessFile( char *pszPath, char *pszFilename );
static BOOL ProcessMetafileRecords( FILE* fp );
local function CheckMetafileHeaderRecord( ENHMETARECORD* pMetafileRecord );

local function PrintMetafileHeader( ENHMETAHEADER* pMetafileHeader );
local function PrintMetafileRecord( ENHMETARECORD* pMetafileRecord );
local function Print_GenericMetafileRecord( ENHMETARECORD* pMetafileRecord );
local function Print_ExtCreateFontIndirectW( ENHMETARECORD* pMetaRecord );
local function Print_ExtCreatePen( ENHMETARECORD* pMetaRecord );
local function Print_ExtTextOutW( ENHMETARECORD* pMetaRecord );
local function ZeroOutUnusedStringSpaceW( wchar_t* pwcString, size_t stSizeofString );
local function GetFunctionNameFromId( DWORD dwId, char* pszName, size_t stSizeofName );
static int GetTableIndexFromId( DWORD dwId, PID_NAME_PAIR pTable, int nCount );
static int GetTableIndexFromName( char* pszName, PID_NAME_PAIR pTable, int nCount );
--]]

local function main( int argc, char *argv[] )
    ProcessFile( szPath, info.name );

--[[

   if ( !ProcessArguments( argc, argv ) || !g_pszFilespec )
   {
      printf( "Description: Lists records in Windows enhanced metafiles (EMF files).\n" );
      printf( "\n" );
      printf( "     Syntax: listemf filespec [/NO_FILE] [/NO_HEADERS] [/NO_RECORDS]\n" );
      printf( "                              [/NO_SIZE] [/NO_DATA] [/NO_DESCRIPTION]\n" );
      printf( "                              [/NO_LARGE_DATA_SETS] [/FUNCTIONS_ONLY]\n" );
      printf( "\n" );
      printf( "   Examples: listemf myfile.emf\n" );
      printf( "             listemf *.emf /NO_FILE /NO_DESCRIPTION\n" );
      printf( "             listemf *.emf /NO_RECORDS\n" );
      printf( "             listemf *.emf /NO_SIZE /NO_DATA\n" );
      printf( "             listemf *.emf /FUNCTIONS_ONLY\n" );
      printf( "\n" );
   }
   else {

      char szPath[_MAX_PATH];
      char szDrive[_MAX_DRIVE];
      char szDir[_MAX_DIR];

      struct _finddata_t info;
      long hFile;

      hFile = _findfirst( g_pszFilespec, &info );

      if ( hFile != -1 ) {

         _splitpath( g_pszFilespec, szDrive, szDir, NULL, NULL );
         _makepath( szPath, szDrive, szDir, NULL, NULL );

         ProcessFile( szPath, info.name );

         while ( _findnext( hFile, &info ) == 0 )
            ProcessFile( szPath, info.name );

         _findclose( hFile );

      }
      else {
         error( PEERROR_FILE_NOT_FOUND );
         exit( 1 );
      }

    end
--]]
end
--[[
BOOL ProcessArguments( int argc, char *argv[] )
{

   enum ArgId_t {
      ARG_NO_SIZE, 
      ARG_NO_DATA,
      ARG_NO_LARGE_DATA_SETS,
      ARG_NO_HEADERS,
      ARG_NO_FILE,
      ARG_NO_RECORDS,
      ARG_NO_DESCRIPTION,
      ARG_FUNCTIONS_ONLY,
   };

   ID_NAME_PAIR ArgNameLookupTable[] = {
      ARG_NO_SIZE,            "NO_SIZE",
      ARG_NO_DATA,            "NO_DATA",               
      ARG_NO_LARGE_DATA_SETS, "NO_LARGE_DATA_SETS",
      ARG_NO_HEADERS,         "NO_HEADERS",               
      ARG_NO_FILE,            "NO_FILE",               
      ARG_NO_RECORDS,         "NO_RECORDS",               
      ARG_NO_DESCRIPTION,     "NO_DESCRIPTION",               
      ARG_FUNCTIONS_ONLY,     "FUNCTIONS_ONLY",               
   };

   BOOL bProcessed = TRUE;
   int i;

   for ( i = 1; ( i < argc ) && bProcessed; ++i )
   {

      if ( argv[i][0] == '/' )
      {

         switch ( GetTableIndexFromName( &argv[i][1], ArgNameLookupTable, DIM( ArgNameLookupTable ) ) )
         {
         
            case ARG_NO_SIZE:
                 g_bPrintSize = FALSE;
                 break;

            case ARG_NO_DATA:
                 g_bPrintData = FALSE;
                 break;

            case ARG_NO_LARGE_DATA_SETS:
                 g_bPrintLargeDataSets = FALSE;
                 break;

            case ARG_NO_HEADERS:
                 g_bPrintHeaders = FALSE;
                 break;

            case ARG_NO_FILE:
                 g_bPrintFile = FALSE;
                 break;

            case ARG_NO_RECORDS:
                 g_bPrintRecords = FALSE;
                 break;

            case ARG_NO_DESCRIPTION:
                 g_bPrintDescription = FALSE;
                 break;

            case ARG_FUNCTIONS_ONLY:
                 g_bPrintFile    = FALSE;
                 g_bPrintHeaders = FALSE;
                 g_bPrintSize    = FALSE;
                 g_bPrintData    = FALSE;
                 g_bPrintRecords = TRUE;
                 break;

            default:
                 bProcessed = FALSE;
                 printf( "\7Invalid command line argument: %s\n", argv[i] );
                 break;

         }

      }
      else g_pszFilespec = argv[i];

   }

   return bProcessed;

}
--]]

local function error( nError )
   assert( ISBETWEEN( nError, PEERROR_FIRST, PEERROR_LAST ) );

   if ISBETWEEN( nError, PEERROR_FIRST, PEERROR_LAST ) then
        printf( "\7Error %d: %s\n", nError, pszErrorMessage[ nError ]);
   else
        printf( "\7Error %d: %s\n", nError, "Unknown error" );
   end
end

local function ProcessFile( pszPath, pszFilename )


   BOOL bProcessed = FALSE;
   char szFullFilename[ _MAX_PATH ];
   FILE *fp;

   // assemble the full filename
   strncpy( szFullFilename, pszPath, sizeof szFullFilename );
   strncat( szFullFilename, pszFilename, sizeof szFullFilename );

   if ( g_bPrintFile )
      printf( "File: %s\n", szFullFilename );

   /* try to open the file. */
   fp = fopen( szFullFilename, "rb" );
   ASSERT( fp );

   /* if opened successfully */
   if ( fp )  
   {

      char ext[ _MAX_EXT ];

      /* get the filename extension */
      _splitpath( szFullFilename, NULL, NULL, NULL, ext );
  
      /* if the file is an enhanced metafile as per the normal naming conventions */
      if ( stricmp( ext, ".EMF" ) == 0 )
         bProcessed = ProcessMetafileRecords( fp );
      else error( PEERROR_NOT_AN_EMF_FILE );
  
   }
   else error( PEERROR_FILE_NOT_FOUND );

   -- done with file so close it
   fclose( fp );

   -- separate one file's output from another
   printf( "\n" );

   return bProcessed;
  
end

local function ProcessMetafileRecords( FILE* fp )


   BOOL bDone;
   BOOL bProcessed;

   bDone = FALSE;
   bProcessed = TRUE;
   g_bCheckMetafileHeaderRecord = TRUE;

   while ( bProcessed && !bDone && !feof( fp ) ) 
   {

      ENHMETARECORD MetaRecordHeader;

      bProcessed = fread( &MetaRecordHeader, sizeof MetaRecordHeader, 1, fp ) == 1;
      ASSERT( bProcessed );

      if ( bProcessed && !bDone )
      {

         ENHMETARECORD* pMetaRecord = ( ENHMETARECORD* )malloc( MetaRecordHeader.nSize );

         if ( pMetaRecord )
         {

            fseek( fp, -( long )( sizeof MetaRecordHeader ), SEEK_CUR );

            bProcessed = fread( pMetaRecord, MetaRecordHeader.nSize, 1, fp ) == 1;
            ASSERT( bProcessed );

            if ( bProcessed )
            {
               if ( g_bPrintRecords )
                  PrintMetafileRecord( pMetaRecord );
            }
            else error( PEERROR_READING_METAFILE_RECORD );

            free( pMetaRecord );

         }
         else 
         {

            error( PEERROR_ALLOCATING_MEMORY_FOR_RECORD );
            printf( "Function 0x%04hX, Size 0x%08lX\n", MetaRecordHeader.iType, MetaRecordHeader.nSize ); 

            fseek( fp, MetaRecordHeader.nSize - sizeof MetaRecordHeader, SEEK_CUR );

         }

      }

      bDone = ( MetaRecordHeader.iType == EMR_EOF );

   }

   return bProcessed;

end

--typedef void ( *PF_PRINT )( ENHMETARECORD* pMetafileRecord );

local function PrintMetafileRecord( ENHMETARECORD* pMetafileRecord )

   local PrintTable = {

           -- just handle a few special records for now...
           EMR_EXTCREATEFONTINDIRECTW, Print_ExtCreateFontIndirectW,
           EMR_EXTCREATEPEN,           Print_ExtCreatePen,
           EMR_EXTTEXTOUTW,            Print_ExtTextOutW,

           #ifdef COMMENT
           EMR_CREATEBRUSHINDIRECT,    Print_CreateBrushIndirect,
           EMR_CREATEMONOBRUSH,        Print_CreateMonoBrush,
           EMR_CREATEPALETTE,          Print_CreatePalette,
           EMR_CREATEPEN,              Print_CreatePen,
           EMR_DELETEOBJECT,           Print_DeleteObject,
           EMR_ELLIPSE,                Print_Ellipse,
           EMR_EOF,                    Print_Eof,
           EMR_EXTCREATEFONTINDIRECTW, Print_ExtCreateFontIndirectW,
           EMR_EXTSELECTCLIPRGN,       Print_ExtSelectClipRgn,
           EMR_EXTTEXTOUTW,            Print_ExtTextOutW,
           EMR_GDICOMMENT,             Print_GdiComment,
           EMR_HEADER,                 Print_Header,
           EMR_LINETO,                 Print_LineTo,
           EMR_MOVETOEX,               Print_MoveToEx,
           EMR_POLYGON,                Print_Polygon,
           EMR_POLYGON16,              Print_Polygon16,
           EMR_POLYLINE,               Print_Polyline,
           EMR_POLYLINE16,             Print_Polyline16,
           EMR_POLYPOLYGON,            Print_PolyPolygon,
           EMR_POLYPOLYGON16,          Print_PolyPolygon16,
           EMR_POLYPOLYLINE,           Print_PolyPolyline,
           EMR_POLYPOLYLINE16,         Print_PolyPolyline16,
           EMR_REALIZEPALETTE,         Print_RealizePalette,
           EMR_RECTANGLE,              Print_Rectangle,
           EMR_SELECTOBJECT,           Print_SelectObject,
           EMR_SELECTPALETTE,          Print_SelectPalette,
           EMR_SETBKCOLOR,             Print_SetBkColor,
           EMR_SETBKMODE,              Print_SetBkMode,
           EMR_SETMAPMODE,             Print_SetMapMode,
           EMR_SETPOLYFILLMODE,        Print_SetPolyFillMode,
           EMR_SETROP2,                Print_SetROP2,
           EMR_SETTEXTALIGN,           Print_SetTextAlign,
           EMR_SETTEXTCOLOR,           Print_SetTextColor,
           EMR_SETVIEWPORTEXTEX,       Print_SetViewportExtEx,
           EMR_SETVIEWPORTORGEX,       Print_SetViewportOrgEx,
           EMR_SETWINDOWEXTEX,         Print_SetWindowExtEx,
           EMR_SETWINDOWORGEX,         Print_SetWindowOrgEx,
           #endif
         };

   -- look for record in table
   for ( int i = 0; i < DIM( PrintTable ); ++i )
       if ( PrintTable[ i ].iType == pMetafileRecord->iType )
          break;

   -- if we found it, print the specific the record
   if ( i < DIM( PrintTable ) )
      ( *PrintTable[ i ].pfPrint )( pMetafileRecord );

   -- else it's unknown, print a generic record
   else 
    Print_GenericMetafileRecord( pMetafileRecord );
   end
end

local function Print_ExtCreateFontIndirectW( ENHMETARECORD* pMetaRecord )
{

   EMREXTCREATEFONTINDIRECTW* pEmrExtCreateFontIndirectW = ( EMREXTCREATEFONTINDIRECTW* )pMetaRecord;   

   // clear out random "garbage" bytes from record so we can accurately compare files 
   ZeroOutUnusedStringSpaceW( pEmrExtCreateFontIndirectW->elfw.elfLogFont.lfFaceName, LF_FACESIZE );
   ZeroOutUnusedStringSpaceW( pEmrExtCreateFontIndirectW->elfw.elfFullName, LF_FULLFACESIZE );
   ZeroOutUnusedStringSpaceW( pEmrExtCreateFontIndirectW->elfw.elfStyle, LF_FACESIZE );

   // clear out any pad bytes after EXTLOGFONTW struct (added in V1.20)
   BYTE* pEndOfStruct = ( ( BYTE* )&pEmrExtCreateFontIndirectW->elfw ) + sizeof( EXTLOGFONTW );
   BYTE* pEndOfRecord = ( ( BYTE* )pMetaRecord ) + pMetaRecord->nSize;

   size_t stPadByteCount = pEndOfRecord - pEndOfStruct;
   ASSERT( stPadByteCount < 4 );

   if ( stPadByteCount < 4 )
      while ( pEndOfStruct < pEndOfRecord )
         *pEndOfStruct++ = 0;

   // now, print it!
   Print_GenericMetafileRecord( pMetaRecord );

}

local function Print_ExtCreatePen( ENHMETARECORD* pMetaRecord )
{

   // this routine added for V1.20

   EMREXTCREATEPEN* pEmrExtCreatePen = ( EMREXTCREATEPEN* )pMetaRecord;   

   // clear out random "garbage" bytes from record so we can accurately compare files 
   if (    ( pEmrExtCreatePen->elp.elpBrushStyle == BS_SOLID ) 
        || ( pEmrExtCreatePen->elp.elpBrushStyle == BS_HOLLOW ) )
      pEmrExtCreatePen->elp.elpHatch = 0;

   Print_GenericMetafileRecord( pMetaRecord );

}

local function Print_ExtTextOutW( ENHMETARECORD* pMetaRecord )
{

   EMREXTTEXTOUTW* pEmrExtTextOutW = ( EMREXTTEXTOUTW* )pMetaRecord;   
   EMRTEXT* pEmrText = &pEmrExtTextOutW->emrtext;

   // clear out random "garbage" byte from record so we can accurately compare files 
   //
   // if string has an odd number of chars, there's one garbage wchar_t that needs to be cleared
   if ( pEmrText->nChars % 2 )
   {
      WCHAR* pStringW = ( WCHAR* )( ( BYTE* )pEmrExtTextOutW + pEmrText->offString );
      memset( pStringW + pEmrText->nChars, 0, sizeof( WCHAR ) );
   }

   Print_GenericMetafileRecord( pMetaRecord );

}

local function ZeroOutUnusedStringSpaceW( wchar_t* pwcString, size_t stSizeofString )
{

   size_t stStringLength = wcslen( pwcString );

   ASSERT( stStringLength < stSizeofString );

   if ( stStringLength < stSizeofString )
      memset( pwcString + stStringLength + 1, 
              0, 
              ( stSizeofString - ( stStringLength + 1 ) ) * sizeof ( wchar_t ) );

}

#ifdef COMMENT

local function Print_CreateBrushIndirect( const ENHMETARECORD* pMetaRecord )
{

   EMRCREATEBRUSHINDIRECT* pEmrCreateBrushIndirect = ( EMRCREATEBRUSHINDIRECT* )pMetaRecord;   

   return m_pEmfConverter->Convert_CreateBrushIndirect( pEmrCreateBrushIndirect->ihBrush, 
                                                        &pEmrCreateBrushIndirect->lb );
   printf( "CreateBrushIndirect( %d, 0x%X )\n" ), 
           pEmrCreateBrushIndirect->ihBrush, 
           m_bTraceAddress ? kpLogbrush : 0 );
   dump( "kpLogbrush", kpLogbrush, sizeof( LOGBRUSH ) );

}

local function Print_CreateMonoBrush( const ENHMETARECORD* pMetaRecord )
{

   EMRCREATEMONOBRUSH* pEmrCreateMonoBrush = ( EMRCREATEMONOBRUSH* )pMetaRecord;   

   BITMAPINFO* pBitmapInfo = ( BITMAPINFO* )(   ( BYTE* )pEmrCreateMonoBrush 
                                              + pEmrCreateMonoBrush->offBmi );

   BYTE* pBitmapBits = ( BYTE* )pEmrCreateMonoBrush + pEmrCreateMonoBrush->offBits;

   return m_pEmfConverter->Convert_CreateMonoBrush( pEmrCreateMonoBrush->ihBrush,
                                                    pEmrCreateMonoBrush->iUsage,
                                                    pBitmapInfo,
                                                    pEmrCreateMonoBrush->cbBmi,
                                                    pBitmapBits,
                                                    pEmrCreateMonoBrush->cbBits );

}

local function Print_CreatePalette( const ENHMETARECORD* pMetaRecord )
{

   EMRCREATEPALETTE* pEmrCreatePalette = ( EMRCREATEPALETTE* )pMetaRecord;   

   return m_pEmfConverter->Convert_CreatePalette( pEmrCreatePalette->ihPal, &pEmrCreatePalette->lgpl );

}

local function Print_CreatePen( const ENHMETARECORD* pMetaRecord )
{

   EMRCREATEPEN* pEmrCreatePen = ( EMRCREATEPEN* )pMetaRecord;   

   return m_pEmfConverter->Convert_CreatePen( pEmrCreatePen->ihPen, &pEmrCreatePen->lopn );

}

local function Print_DeleteObject( const ENHMETARECORD* pMetaRecord )
{

   EMRDELETEOBJECT* pEmrDeleteObject = ( EMRDELETEOBJECT* )pMetaRecord;   

   return m_pEmfConverter->Convert_DeleteObject( pEmrDeleteObject->ihObject );
   
}

local function Print_Ellipse( const ENHMETARECORD* pMetaRecord )
{

   EMRELLIPSE* pEmrEllipse = ( EMRELLIPSE* )pMetaRecord;   

   return m_pEmfConverter->Convert_Ellipse( ( RECT* )&pEmrEllipse->rclBox );

}

local function Print_Eof( const ENHMETARECORD* pMetaRecord )
{

   EMREOF* pEmrEof = ( EMREOF* )pMetaRecord;   

   // FUTURE: Handle the optional palette in this record?
   return m_pEmfConverter->Convert_Eof( pMetaRecord );

}

local function Print_ExtCreateFontIndirectW( const ENHMETARECORD* pMetaRecord )
{

   EMREXTCREATEFONTINDIRECTW* pEmrExtCreateFontIndirectW = ( EMREXTCREATEFONTINDIRECTW* )pMetaRecord;   

   #ifdef UNICODE

   return m_pEmfConverter->Convert_ExtCreateFontIndirect( pEmrExtCreateFontIndirectW->ihFont,
                                                          &pEmrExtCreateFontIndirectW->elfw.elfLogFont );

   #else

   LOGFONTA logfonta;

   LogfontWToLogfontA( &pEmrExtCreateFontIndirectW->elfw.elfLogFont, &logfonta );

   return m_pEmfConverter->Convert_ExtCreateFontIndirect( pEmrExtCreateFontIndirectW->ihFont, &logfonta );

   #endif // UNICODE

}

local function Print_ExtCreatePen( const ENHMETARECORD* pMetaRecord )
{

   EMREXTCREATEPEN* pEmrExtCreatePen = ( EMREXTCREATEPEN* )pMetaRecord;   

   BITMAPINFO* pBitmapInfo = ( BITMAPINFO* )( ( BYTE* )pEmrExtCreatePen + pEmrExtCreatePen->offBmi );

   BYTE* pBitmapBits = ( BYTE* )pEmrExtCreatePen + pEmrExtCreatePen->offBits;

   LOGBRUSH logbrush;
   logbrush.lbStyle = pEmrExtCreatePen->elp.elpBrushStyle;
   logbrush.lbColor = pEmrExtCreatePen->elp.elpColor;
   logbrush.lbHatch = pEmrExtCreatePen->elp.elpHatch;

   return m_pEmfConverter->Convert_ExtCreatePen( pEmrExtCreatePen->ihPen, 
                                                 pEmrExtCreatePen->elp.elpPenStyle,
                                                 pEmrExtCreatePen->elp.elpWidth,
                                                 &logbrush,
                                                 pEmrExtCreatePen->elp.elpNumEntries,
                                                   ( pEmrExtCreatePen->elp.elpNumEntries > 0 )
                                                 ? pEmrExtCreatePen->elp.elpStyleEntry
                                                 : NULL );

}

local function Print_ExtSelectClipRgn( const ENHMETARECORD* pMetaRecord )
{

   ConvertStatus status = CS_ERROR;

   EMREXTSELECTCLIPRGN* pEmrExtSelectClipRgn = ( EMREXTSELECTCLIPRGN* )pMetaRecord;   
   
	HRGN hrgn;

	if ( pEmrExtSelectClipRgn->cbRgnData != 0 )
	{

	   hrgn = ( HRGN )GlobalAlloc( GHND, pEmrExtSelectClipRgn->cbRgnData );

		ASSERT( hrgn );

		if ( hrgn )
		{

		 	void* pvRegion = GlobalLock( hrgn );

			ASSERT( pvRegion );

			if ( pvRegion )
			{
			   memcpy( pvRegion, pEmrExtSelectClipRgn->RgnData, pEmrExtSelectClipRgn->cbRgnData );
				GlobalUnlock( hrgn );
			}
			else 
			{
				GlobalFree( hrgn );
				hrgn = NULL;
			}

		}

	}
	else hrgn = NULL;

   status = m_pEmfConverter->Convert_ExtSelectClipRgn( hrgn, pEmrExtSelectClipRgn->iMode );

	if ( hrgn )
	   GlobalFree( hrgn );

   return status;

}

local function Print_ExtTextOutW( const ENHMETARECORD* pMetaRecord )
{

   ConvertStatus status = CS_ERROR;

   EMREXTTEXTOUTW* pEmrExtTextOutW = ( EMREXTTEXTOUTW* )pMetaRecord;   
   EMRTEXT* pEmrText = &pEmrExtTextOutW->emrtext;

   WCHAR* pStringW;
   TCHAR* pString;

   pStringW = ( WCHAR* )( ( char* )pEmrExtTextOutW + pEmrText->offString );

   #ifdef UNICODE

   pString = pStringW;

   #else

   pString = AllocMultiByteFromWideChar( pStringW, pEmrText->nChars );

   #endif UNICODE

   // finally, convert the record
   if ( pString )
   {
      status = m_pEmfConverter->Convert_ExtTextOut( *( POINT* )&pEmrText->ptlReference, 
                                                    pEmrText->fOptions, 
                                                    ( RECT* )&pEmrText->rcl, 
                                                    pString, 
                                                    pEmrText->nChars, 
                                                    ( int* )( ( char* )pEmrText + pEmrText->offDx ) );
      #ifndef UNICODE
      // release the string we allocated
      free( pString );
      #endif
   }

   return status;

}

local function Print_GdiComment( const ENHMETARECORD* pMetaRecord )
{

   EMRGDICOMMENT* pEmrGdiComment = ( EMRGDICOMMENT* )pMetaRecord;   

   return m_pEmfConverter->Convert_GdiComment( pEmrGdiComment->Data, pEmrGdiComment->cbData );
   
}

local function Print_Header( const ENHMETARECORD* pMetaRecord )
{

   return m_pEmfConverter->Convert_Header( ( ENHMETAHEADER* )pMetaRecord );

}

local function Print_LineTo( const ENHMETARECORD* pMetaRecord )
{

   EMRLINETO* pEmrLineTo = ( EMRLINETO* )pMetaRecord;   

   return m_pEmfConverter->Convert_LineTo( *( POINT* )&pEmrLineTo->ptl );
   
}

local function Print_MoveToEx( const ENHMETARECORD* pMetaRecord )
{

   EMRMOVETOEX* pEmrMoveToEx = ( EMRMOVETOEX* )pMetaRecord;   

   return m_pEmfConverter->Convert_MoveToEx( *( POINT* )&pEmrMoveToEx->ptl );
   
}

local function Print_Polygon( const ENHMETARECORD* pMetaRecord )
{

   EMRPOLYGON* pEmrPolygon = ( EMRPOLYGON* )pMetaRecord;   

   return m_pEmfConverter->Convert_Polygon( ( POINT* )pEmrPolygon->aptl, pEmrPolygon->cptl );
   
}

local function Print_Polygon16( const ENHMETARECORD* pMetaRecord )
{

   ConvertStatus status = CS_ERROR;

   EMRPOLYGON16* pEmrPolygon16 = ( EMRPOLYGON16* )pMetaRecord;

   int nCount = pEmrPolygon16->cpts;

   POINT* pPoints = AllocPointsFromPoints16( ( POINT16* )pEmrPolygon16->apts, nCount );

   if ( pPoints )
   {
      status = m_pEmfConverter->Convert_Polygon( pPoints, nCount );
      free( pPoints );
   }

   return status;
   
}

local function Print_Polyline( const ENHMETARECORD* pMetaRecord )
{

   EMRPOLYLINE* pEmrPolyline = ( EMRPOLYLINE* )pMetaRecord;   

   return m_pEmfConverter->Convert_Polyline( ( POINT* )pEmrPolyline->aptl, pEmrPolyline->cptl );

}

local function Print_Polyline16( const ENHMETARECORD* pMetaRecord )
{

   ConvertStatus status = CS_ERROR;

   EMRPOLYLINE16* pEmrPolyline16 = ( EMRPOLYLINE16* )pMetaRecord;

   int nCount = pEmrPolyline16->cpts;

   POINT* pPoints = AllocPointsFromPoints16( ( POINT16* )pEmrPolyline16->apts, nCount );

   if ( pPoints )
   {
      status = m_pEmfConverter->Convert_Polyline( pPoints, nCount );
      free( pPoints );
   }

   return status;
   
}

local function Print_PolyPolygon( const ENHMETARECORD* pMetaRecord )
{

   EMRPOLYPOLYGON* pEmrPolyPolygon = ( EMRPOLYPOLYGON* )pMetaRecord;

   int nPolygonCount = pEmrPolyPolygon->nPolys;
   int* pnPointCounts = ( int* )pEmrPolyPolygon->aPolyCounts;
   POINT* pPoints = ( POINT* )&pnPointCounts[ nPolygonCount ];

   return m_pEmfConverter->Convert_PolyPolygon( pPoints, pnPointCounts, nPolygonCount );

}

local function Print_PolyPolygon16( const ENHMETARECORD* pMetaRecord )
{

   ConvertStatus status;

   EMRPOLYPOLYGON16* pEmrPolyPolygon16 = ( EMRPOLYPOLYGON16* )pMetaRecord;

   int nPolygonCount = pEmrPolyPolygon16->nPolys;
   int* pnPointCounts = ( int* )pEmrPolyPolygon16->aPolyCounts;
   POINT16* pPoints16 = ( POINT16* )&pnPointCounts[ nPolygonCount ];
   int nTotalPointsCount = pEmrPolyPolygon16->cpts;

   // allocate a 32-bit points array
   POINT* pPoints = AllocPointsFromPoints16( pPoints16, nTotalPointsCount );

   if ( pPoints )
   {
      status = m_pEmfConverter->Convert_PolyPolygon( pPoints, pnPointCounts, nPolygonCount );
      free( pPoints );
   }

   return status;

}

local function Print_PolyPolyline( const ENHMETARECORD* pMetaRecord )
{

   EMRPOLYPOLYLINE* pEmrPolyPolyline = ( EMRPOLYPOLYLINE* )pMetaRecord;

   int nPolylineCount = pEmrPolyPolyline->nPolys;
   int* pnPointCounts = ( int* )pEmrPolyPolyline->aPolyCounts;
   POINT* pPoints = ( POINT* )&pnPointCounts[ nPolylineCount ];

   return m_pEmfConverter->Convert_PolyPolyline( pPoints, pnPointCounts, nPolylineCount );

}

local function Print_PolyPolyline16( const ENHMETARECORD* pMetaRecord )
{

   ConvertStatus status = CS_ERROR;
   
   EMRPOLYPOLYLINE16* pEmrPolyPolyline16 = ( EMRPOLYPOLYLINE16* )pMetaRecord;

   int nPolylineCount = pEmrPolyPolyline16->nPolys;
   int* pnPointCounts = ( int* )pEmrPolyPolyline16->aPolyCounts;
   POINT16* pPoints16 = ( POINT16* )&pnPointCounts[ nPolylineCount ];
   int nTotalPointsCount = pEmrPolyPolyline16->cpts;

   // allocate a 32-bit points array
   POINT* pPoints = AllocPointsFromPoints16( pPoints16, nTotalPointsCount );

   if ( pPoints )
   {
      status = m_pEmfConverter->Convert_PolyPolyline( pPoints, pnPointCounts, nPolylineCount );
      free( pPoints );
   }

   return status;

}

static POINT* AllocPointsFromPoints16( POINT16* pPoints16, int nCount )
{

   POINT* pPoints = NULL;

   ASSERT( pPoints16 );
   ASSERT( nCount > 0 );

   if ( pPoints16 && ( nCount > 0 ) )
   {

      // allocate the 32-bit array
      pPoints = ( POINT* )malloc( nCount * ( sizeof POINT ) );

      // init the 32-bit array to the 16-bit values
      if ( pPoints )
      {

         for ( int i = 0; i < nCount; ++i )
         {
            pPoints[i].x = pPoints16[i].x;
            pPoints[i].y = pPoints16[i].y;
         }

      }

   }

   ASSERT( pPoints );

   return pPoints;

}

#ifdef INCLUDE_UNUSED_CODE

static int* AllocIntsFromInts16( INT16* pInts16, int nCount )
{

   int* pInts = NULL;

   ASSERT( pInts16 );
   ASSERT( nCount > 0 );

   if ( pInts16 && ( nCount > 0 ) )
   {

      // allocate the 32-bit array
      pInts = ( int* )malloc( nCount * sizeof ( int ) );

      // init the 32-bit array to the 16-bit values
      if ( pInts )
         for ( int i = 0; i < nCount; ++i )
            pInts[i] = pInts16[i];

   }

   ASSERT( pInts );

   return pInts;

}

#endif // INCLUDE_UNUSED_CODE

local function Print_RealizePalette( const ENHMETARECORD* pMetaRecord )
{

   return m_pEmfConverter->Convert_RealizePalette();
   
}

local function Print_Rectangle( const ENHMETARECORD* pMetaRecord )
{

   EMRRECTANGLE* pEmrRectangle = ( EMRRECTANGLE* )pMetaRecord;   

   return m_pEmfConverter->Convert_Rectangle( ( RECT* )&pEmrRectangle->rclBox );

}

local function Print_SelectObject( const ENHMETARECORD* pMetaRecord )
{

   EMRSELECTOBJECT* pEmrSelectObject = ( EMRSELECTOBJECT* )pMetaRecord;

   return m_pEmfConverter->Convert_SelectObject( pEmrSelectObject->ihObject );
   
}

local function Print_SelectPalette( const ENHMETARECORD* pMetaRecord )
{

   EMRSELECTPALETTE* pEmrSelectPalette = ( EMRSELECTPALETTE* )pMetaRecord;

   return m_pEmfConverter->Convert_SelectPalette( pEmrSelectPalette->ihPal );
   
}

local function Print_SetBkColor( const ENHMETARECORD* pMetaRecord )
{

   EMRSETBKCOLOR* pEmrSetBkColor = ( EMRSETBKCOLOR* )pMetaRecord;

   return m_pEmfConverter->Convert_SetBkColor( pEmrSetBkColor->crColor );
   
}

local function Print_SetBkMode( const ENHMETARECORD* pMetaRecord )
{

   EMRSETBKMODE* pEmrSetBkMode = ( EMRSETBKMODE* )pMetaRecord;

   return m_pEmfConverter->Convert_SetBkMode( pEmrSetBkMode->iMode );
   
}

local function Print_SetMapMode( const ENHMETARECORD* pMetaRecord )
{

   EMRSETMAPMODE* pEmrSetMapMode = ( EMRSETMAPMODE* )pMetaRecord;

   return m_pEmfConverter->Convert_SetMapMode( pEmrSetMapMode->iMode );
   
}

local function Print_SetPolyFillMode( const ENHMETARECORD* pMetaRecord )
{

   EMRSETPOLYFILLMODE* pEmrSetPolyFillMode = ( EMRSETMAPMODE* )pMetaRecord;

   return m_pEmfConverter->Convert_SetPolyFillMode( pEmrSetPolyFillMode->iMode );
   
}

local function Print_SetROP2( const ENHMETARECORD* pMetaRecord )
{

   EMRSETROP2* pEmrSetRop2 = ( EMRSETROP2* )pMetaRecord;

   return m_pEmfConverter->Convert_SetROP2( pEmrSetRop2->iMode );
   
}

local function Print_SetTextAlign( const ENHMETARECORD* pMetaRecord )
{

   EMRSETTEXTALIGN* pEmrSetTextAlign = ( EMRSETTEXTALIGN* )pMetaRecord;

   return m_pEmfConverter->Convert_SetTextAlign( pEmrSetTextAlign->iMode );
   
}

local function Print_SetTextColor( const ENHMETARECORD* pMetaRecord )
{

   EMRSETTEXTCOLOR* pEmrSetTextColor = ( EMRSETTEXTCOLOR* )pMetaRecord;

   return m_pEmfConverter->Convert_SetTextColor( pEmrSetTextColor->crColor );
   
}

local function Print_SetViewportExtEx( const ENHMETARECORD* pMetaRecord )
{

   EMRSETVIEWPORTEXTEX* pEmrSetViewportExtEx = ( EMRSETVIEWPORTEXTEX* )pMetaRecord;

   return m_pEmfConverter->Convert_SetViewportExtEx( *( SIZE* )&pEmrSetViewportExtEx->szlExtent );
   
}

local function Print_SetViewportOrgEx( const ENHMETARECORD* pMetaRecord )
{

   EMRSETVIEWPORTORGEX* pEmrSetViewportOrgEx = ( EMRSETVIEWPORTORGEX* )pMetaRecord;

   return m_pEmfConverter->Convert_SetViewportOrgEx( *( POINT* )&pEmrSetViewportOrgEx->ptlOrigin );

}

local function Print_SetWindowExtEx( const ENHMETARECORD* pMetaRecord )
{

   EMRSETWINDOWEXTEX* pEmrSetWindowExtEx = ( EMRSETWINDOWEXTEX* )pMetaRecord;

   return m_pEmfConverter->Convert_SetWindowExtEx( *( SIZE* )&pEmrSetWindowExtEx->szlExtent );
   
}

local function Print_SetWindowOrgEx( const ENHMETARECORD* pMetaRecord )
{

   EMRSETWINDOWORGEX* pEmrSetWindowOrgEx = ( EMRSETWINDOWORGEX* )pMetaRecord;

   return m_pEmfConverter->Convert_SetWindowOrgEx( *( POINT* )&pEmrSetWindowOrgEx->ptlOrigin );

}

#endif

local function Print_GenericMetafileRecord( ENHMETARECORD* pMetafileRecord )
{

   if ( g_bPrintRecords )
   {

      #define NUM_INTS_PER_ROW 5
      #define LARGE_DATA_SET_COUNT ( NUM_INTS_PER_ROW + 1 )

      char szName[ 80 ];

      local szName = emrcodec.RecordType(pMetafileRecord->iType)


      printf( "%s", szName );

      if ( g_bPrintSize ) then
         printf( " ( %ld bytes )", pMetafileRecord->nSize );
      end

      if ( g_bCheckMetafileHeaderRecord ) then
      
         printf( "\n" );
         CheckMetafileHeaderRecord( pMetafileRecord );
         PrintMetafileHeader( ( ENHMETAHEADER* )pMetafileRecord );
         g_bCheckMetafileHeaderRecord = FALSE;
      
      else
      
         if (    g_bPrintData 
              && (    g_bPrintLargeDataSets 
                   || ( ( pMetafileRecord->nSize / sizeof ( DWORD ) ) < LARGE_DATA_SET_COUNT ) ) )
         {

            DWORD dw;
            DWORD dwSize;

            printf( "\n" );
            dwSize = ( pMetafileRecord->nSize - ( 2 * sizeof( DWORD ) ) ) / sizeof( DWORD );  
            for ( dw = 0; dw < dwSize; ++dw )
            {

               if ( ( dw % NUM_INTS_PER_ROW ) == 0 )
                  printf( "   " );

               printf( "%11d", pMetafileRecord->dParm[ dw ] );

               if ( ( ( ( dw + 1 ) % NUM_INTS_PER_ROW ) == 0 ) || ( dw == ( dwSize - 1 ) ) )
                  printf( "\n" );
               else printf( "  " );

            }

         }
         else 
            printf( "\n" );
         end
    end

   }

end

local function GetFunctionNameFromId( DWORD dwId, char* pszName, size_t stSizeofName )


   local funcName = emrcodec.RecordType(dwId)
    if not funcName then
        funcName = "Unknown function"
        end

   -- if we found the entry, get its name - else "make up a name"
   if ( i != -1 )
      strncpy( pszName, EmfFunctionLookupTable[i].pszName, stSizeofName );
   else 
    sprintf( pszName, "Unknown function: %hX", dwId );
    end
end

static int GetTableIndexFromId( DWORD dwId, PID_NAME_PAIR pTable, int nCount )
{

   int i;
   int nIndex = -1;

   for ( i = 0; i < nCount; ++i )
      if ( dwId == pTable[i].dwId )
      {
         nIndex = i;
         break;
      }

   return nIndex;

}

static int GetTableIndexFromName( char* pszName, PID_NAME_PAIR pTable, int nCount )
{

   int i;
   int nIndex = -1;

   for ( i = 0; i < nCount; ++i )
      if ( stricmp( pszName, pTable[i].pszName ) == 0 )
      {
         nIndex = i;
         break;
      }

   return nIndex;

}

local function CheckMetafileHeaderRecord( ENHMETARECORD* pMetafileRecord )
{

   // simple check for valid header type
   if (    ( pMetafileRecord->iType != EMR_HEADER ) 
        || ( ( ( ENHMETAHEADER* )pMetafileRecord )->dSignature != ENHMETA_SIGNATURE ) )
      error( PEERROR_INVALID_METAFILE_HEADER_TYPE );

}

local function PrintMetafileHeader( ENHMETAHEADER* pMetafileHeader )
{

   if ( g_bPrintHeaders )
   {

      printf( "   iType          = %d\n" , pMetafileHeader->iType );
      printf( "   nSize          = %d\n" , pMetafileHeader->nSize );
      printf( "   rclBounds      = RECTL( %d, %d, %d, %d )\n" , 
                                  pMetafileHeader->rclBounds.left, 
                                  pMetafileHeader->rclBounds.top, 
                                  pMetafileHeader->rclBounds.right, 
                                  pMetafileHeader->rclBounds.bottom );
      printf( "   rclFrame       = RECTL( %d, %d, %d, %d )\n" , 
                                  pMetafileHeader->rclFrame.left, 
                                  pMetafileHeader->rclFrame.top, 
                                  pMetafileHeader->rclFrame.right, 
                                  pMetafileHeader->rclFrame.bottom );
      printf( "   dSignature     = 0x%X\n" , pMetafileHeader->dSignature );
      printf( "   nVersion       = 0x%X\n" , pMetafileHeader->nVersion );
      printf( "   nBytes         = %d\n" , pMetafileHeader->nBytes );
      printf( "   nRecords       = %d\n" , pMetafileHeader->nRecords );
      printf( "   nHandles       = %hd\n" , pMetafileHeader->nHandles );
      printf( "   sReserved      = %hd\n" , pMetafileHeader->sReserved );

      printf( "   nDescription   = %d  " , pMetafileHeader->nDescription );
      if ( g_bPrintDescription )
      {

         // "decode" and append the description string of the form: "Application\0Filename\0"
         wchar_t* pwc = ( ( wchar_t* )( ( BYTE* )pMetafileHeader + pMetafileHeader->offDescription ) );
         while ( *pwc )
         {
            printf( "\"%S\" ", pwc );
            pwc += wcslen( pwc ) + 1;
         }

      }
      printf( "\n" );

      printf( "   offDescription = %d\n" , pMetafileHeader->offDescription );
      printf( "   nPalEntries    = %d\n" , pMetafileHeader->nPalEntries );
      printf( "   szlDevice      = SIZEL( %d, %d )\n" , pMetafileHeader->szlDevice.cx, pMetafileHeader->szlDevice.cy );
      printf( "   szlMillimeters = SIZEL( %d, %d )\n" , pMetafileHeader->szlMillimeters.cx, pMetafileHeader->szlMillimeters.cy );

   }

}


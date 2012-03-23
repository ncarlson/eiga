local ffi = require( "ffi" )
local cdef = ([[
typedef unsigned char         PHYSFS_uint8;
typedef signed char           PHYSFS_sint8;
typedef unsigned short        PHYSFS_uint16;
typedef signed short          PHYSFS_sint16;
typedef unsigned int          PHYSFS_uint32;
typedef signed int            PHYSFS_sint32;
// #if (defined PHYSFS_NO_64BIT_SUPPORT)
typedef PHYSFS_uint32         PHYSFS_uint64;
typedef PHYSFS_sint32         PHYSFS_sint64;
// #elif (defined _MSC_VER)
// typedef signed __int64        PHYSFS_sint64;
// typedef unsigned __int64      PHYSFS_uint64;
// #else
// typedef unsigned long long    PHYSFS_uint64;
// typedef signed long long      PHYSFS_sint64;
// #endif

typedef struct PHYSFS_File
{
    void *opaque;
} PHYSFS_File;
typedef struct PHYSFS_ArchiveInfo
{
    const char *extension;
    const char *description;
    const char *author;
    const char *url;
} PHYSFS_ArchiveInfo;
typedef struct PHYSFS_Version
{
    PHYSFS_uint8 major;
    PHYSFS_uint8 minor;
    PHYSFS_uint8 patch;
} PHYSFS_Version;

__EXPORT__ void PHYSFS_getLinkedVersion(PHYSFS_Version *ver);
__EXPORT__ int PHYSFS_init(const char *argv0);
__EXPORT__ int PHYSFS_deinit(void);
__EXPORT__ const PHYSFS_ArchiveInfo **PHYSFS_supportedArchiveTypes(void);
__EXPORT__ void PHYSFS_freeList(void *listVar);
__EXPORT__ const char *PHYSFS_getLastError(void);
__EXPORT__ const char *PHYSFS_getDirSeparator(void);
__EXPORT__ void PHYSFS_permitSymbolicLinks(int allow);
__EXPORT__ char **PHYSFS_getCdRomDirs(void);
__EXPORT__ const char *PHYSFS_getBaseDir(void);
__EXPORT__ const char *PHYSFS_getUserDir(void);
__EXPORT__ const char *PHYSFS_getWriteDir(void);
__EXPORT__ int PHYSFS_setWriteDir(const char *newDir);
__EXPORT__ int PHYSFS_addToSearchPath(const char *newDir, int appendToPath);
__EXPORT__ int PHYSFS_removeFromSearchPath(const char *oldDir);
__EXPORT__ char **PHYSFS_getSearchPath(void);
__EXPORT__ int PHYSFS_setSaneConfig(const char *organization,
                                    const char *appName,
                                    const char *archiveExt,
                                    int includeCdRoms,
                                    int archivesFirst);
__EXPORT__ int PHYSFS_mkdir(const char *dirName);
__EXPORT__ int PHYSFS_delete(const char *filename);
__EXPORT__ const char *PHYSFS_getRealDir(const char *filename);
__EXPORT__ char **PHYSFS_enumerateFiles(const char *dir);
__EXPORT__ int PHYSFS_exists(const char *fname);
__EXPORT__ int PHYSFS_isDirectory(const char *fname);
__EXPORT__ int PHYSFS_isSymbolicLink(const char *fname);
__EXPORT__ PHYSFS_sint64 PHYSFS_getLastModTime(const char *filename);
__EXPORT__ PHYSFS_File *PHYSFS_openWrite(const char *filename);
__EXPORT__ PHYSFS_File *PHYSFS_openAppend(const char *filename);
__EXPORT__ PHYSFS_File *PHYSFS_openRead(const char *filename);
__EXPORT__ int PHYSFS_close(PHYSFS_File *handle);
__EXPORT__ PHYSFS_sint64 PHYSFS_read(PHYSFS_File *handle,
                                     void *buffer,
                                     PHYSFS_uint32 objSize,
                                     PHYSFS_uint32 objCount);
__EXPORT__ PHYSFS_sint64 PHYSFS_write(PHYSFS_File *handle,
                                      const void *buffer,
                                      PHYSFS_uint32 objSize,
                                      PHYSFS_uint32 objCount);
__EXPORT__ int PHYSFS_eof(PHYSFS_File *handle);
__EXPORT__ PHYSFS_sint64 PHYSFS_tell(PHYSFS_File *handle);
__EXPORT__ int PHYSFS_seek(PHYSFS_File *handle, PHYSFS_uint64 pos);
__EXPORT__ PHYSFS_sint64 PHYSFS_fileLength(PHYSFS_File *handle);
__EXPORT__ int PHYSFS_setBuffer(PHYSFS_File *handle, PHYSFS_uint64 bufsize);
__EXPORT__ int PHYSFS_flush(PHYSFS_File *handle);
__EXPORT__ PHYSFS_sint16 PHYSFS_swapSLE16(PHYSFS_sint16 val);
__EXPORT__ PHYSFS_uint16 PHYSFS_swapULE16(PHYSFS_uint16 val);
__EXPORT__ PHYSFS_sint32 PHYSFS_swapSLE32(PHYSFS_sint32 val);
__EXPORT__ PHYSFS_uint32 PHYSFS_swapULE32(PHYSFS_uint32 val);
__EXPORT__ PHYSFS_sint64 PHYSFS_swapSLE64(PHYSFS_sint64 val);
__EXPORT__ PHYSFS_uint64 PHYSFS_swapULE64(PHYSFS_uint64 val);
__EXPORT__ PHYSFS_sint16 PHYSFS_swapSBE16(PHYSFS_sint16 val);
__EXPORT__ PHYSFS_uint16 PHYSFS_swapUBE16(PHYSFS_uint16 val);
__EXPORT__ PHYSFS_sint32 PHYSFS_swapSBE32(PHYSFS_sint32 val);
__EXPORT__ PHYSFS_uint32 PHYSFS_swapUBE32(PHYSFS_uint32 val);
__EXPORT__ PHYSFS_sint64 PHYSFS_swapSBE64(PHYSFS_sint64 val);
__EXPORT__ PHYSFS_uint64 PHYSFS_swapUBE64(PHYSFS_uint64 val);
__EXPORT__ int PHYSFS_readSLE16(PHYSFS_File *file, PHYSFS_sint16 *val);
__EXPORT__ int PHYSFS_readULE16(PHYSFS_File *file, PHYSFS_uint16 *val);
__EXPORT__ int PHYSFS_readSBE16(PHYSFS_File *file, PHYSFS_sint16 *val);
__EXPORT__ int PHYSFS_readUBE16(PHYSFS_File *file, PHYSFS_uint16 *val);
__EXPORT__ int PHYSFS_readSLE32(PHYSFS_File *file, PHYSFS_sint32 *val);
__EXPORT__ int PHYSFS_readULE32(PHYSFS_File *file, PHYSFS_uint32 *val);
__EXPORT__ int PHYSFS_readSBE32(PHYSFS_File *file, PHYSFS_sint32 *val);
__EXPORT__ int PHYSFS_readUBE32(PHYSFS_File *file, PHYSFS_uint32 *val);
__EXPORT__ int PHYSFS_readSLE64(PHYSFS_File *file, PHYSFS_sint64 *val);
__EXPORT__ int PHYSFS_readULE64(PHYSFS_File *file, PHYSFS_uint64 *val);
__EXPORT__ int PHYSFS_readSBE64(PHYSFS_File *file, PHYSFS_sint64 *val);
__EXPORT__ int PHYSFS_readUBE64(PHYSFS_File *file, PHYSFS_uint64 *val);
__EXPORT__ int PHYSFS_writeSLE16(PHYSFS_File *file, PHYSFS_sint16 val);
__EXPORT__ int PHYSFS_writeULE16(PHYSFS_File *file, PHYSFS_uint16 val);
__EXPORT__ int PHYSFS_writeSBE16(PHYSFS_File *file, PHYSFS_sint16 val);
__EXPORT__ int PHYSFS_writeUBE16(PHYSFS_File *file, PHYSFS_uint16 val);
__EXPORT__ int PHYSFS_writeSLE32(PHYSFS_File *file, PHYSFS_sint32 val);
__EXPORT__ int PHYSFS_writeULE32(PHYSFS_File *file, PHYSFS_uint32 val);
__EXPORT__ int PHYSFS_writeSBE32(PHYSFS_File *file, PHYSFS_sint32 val);
__EXPORT__ int PHYSFS_writeUBE32(PHYSFS_File *file, PHYSFS_uint32 val);
__EXPORT__ int PHYSFS_writeSLE64(PHYSFS_File *file, PHYSFS_sint64 val);
__EXPORT__ int PHYSFS_writeULE64(PHYSFS_File *file, PHYSFS_uint64 val);
__EXPORT__ int PHYSFS_writeSBE64(PHYSFS_File *file, PHYSFS_sint64 val);
__EXPORT__ int PHYSFS_writeUBE64(PHYSFS_File *file, PHYSFS_uint64 val);
__EXPORT__ int PHYSFS_isInit(void);
__EXPORT__ int PHYSFS_symbolicLinksPermitted(void);
typedef struct PHYSFS_Allocator
{
    int (*Init)(void);
    void (*Deinit)(void);
    void *(*Malloc)(PHYSFS_uint64);
    void *(*Realloc)(void *, PHYSFS_uint64);
    void (*Free)(void *);
} PHYSFS_Allocator;
__EXPORT__ int PHYSFS_setAllocator(const PHYSFS_Allocator *allocator);
__EXPORT__ int PHYSFS_mount(const char *newDir, const char *mountPoint, int appendToPath);
__EXPORT__ const char *PHYSFS_getMountPoint(const char *dir);
typedef void (*PHYSFS_StringCallback)(void *data, const char *str);
typedef void (*PHYSFS_EnumFilesCallback)(void *data, const char *origdir,
                                         const char *fname);
__EXPORT__ void PHYSFS_getCdRomDirsCallback(PHYSFS_StringCallback c, void *d);
__EXPORT__ void PHYSFS_getSearchPathCallback(PHYSFS_StringCallback c, void *d);
__EXPORT__ void PHYSFS_enumerateFilesCallback(const char *dir,
                                              PHYSFS_EnumFilesCallback c,
                                              void *d);
__EXPORT__ void PHYSFS_utf8FromUcs4(const PHYSFS_uint32 *src, char *dst,
                                    PHYSFS_uint64 len);
__EXPORT__ void PHYSFS_utf8ToUcs4(const char *src, PHYSFS_uint32 *dst,
                                  PHYSFS_uint64 len);
__EXPORT__ void PHYSFS_utf8FromUcs2(const PHYSFS_uint16 *src, char *dst,
                                    PHYSFS_uint64 len);
__EXPORT__ void PHYSFS_utf8ToUcs2(const char *src, PHYSFS_uint16 *dst,
                                  PHYSFS_uint64 len);
__EXPORT__ void PHYSFS_utf8FromLatin1(const char *src, char *dst,
                                  PHYSFS_uint64 len);
]]):gsub("__EXPORT__",ffi.os == "Windows" and "__stdcall" or "")

ffi.cdef(cdef)

local platform_path = string.format("bin/%s/%s/libphysfs.%s", ffi.os, ffi.arch,
                                    jit.os == "OSX" and "dylib" or
                                    jit.os == "Windows" and "dll" or
                                    jit.os == "Linux" and "so")

return ffi.load( platform_path )
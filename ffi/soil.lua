local ffi = require 'ffi'
ffi.cdef [[
enum
{
    SOIL_LOAD_AUTO = 0,
    SOIL_LOAD_L = 1,
    SOIL_LOAD_LA = 2,
    SOIL_LOAD_RGB = 3,
    SOIL_LOAD_RGBA = 4
};

enum
{
    SOIL_CREATE_NEW_ID = 0
};

enum
{
    SOIL_FLAG_POWER_OF_TWO = 1,
    SOIL_FLAG_MIPMAPS = 2,
    SOIL_FLAG_TEXTURE_REPEATS = 4,
    SOIL_FLAG_MULTIPLY_ALPHA = 8,
    SOIL_FLAG_INVERT_Y = 16,
    SOIL_FLAG_COMPRESS_TO_DXT = 32,
    SOIL_FLAG_DDS_LOAD_DIRECT = 64,
    SOIL_FLAG_NTSC_SAFE_RGB = 128,
    SOIL_FLAG_CoCg_Y = 256,
    SOIL_FLAG_TEXTURE_RECTANGLE = 512
};

enum
{
    SOIL_SAVE_TYPE_TGA = 0,
    SOIL_SAVE_TYPE_BMP = 1,
    SOIL_SAVE_TYPE_DDS = 2
};

enum
{
    SOIL_HDR_RGBE = 0,
    SOIL_HDR_RGBdivA = 1,
    SOIL_HDR_RGBdivA2 = 2
};

unsigned int
    SOIL_load_OGL_texture (
        const char *filename,
        int force_channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_load_OGL_cubemap
    (
        const char *x_pos_file,
        const char *x_neg_file,
        const char *y_pos_file,
        const char *y_neg_file,
        const char *z_pos_file,
        const char *z_neg_file,
        int force_channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_load_OGL_single_cubemap
    (
        const char *filename,
        const char face_order[6],
        int force_channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_load_OGL_HDR_texture
    (
        const char *filename,
        int fake_HDR_format,
        int rescale_to_max,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_load_OGL_texture_from_memory
    (
        const unsigned char *const buffer,
        int buffer_length,
        int force_channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_load_OGL_cubemap_from_memory
    (
        const unsigned char *const x_pos_buffer,
        int x_pos_buffer_length,
        const unsigned char *const x_neg_buffer,
        int x_neg_buffer_length,
        const unsigned char *const y_pos_buffer,
        int y_pos_buffer_length,
        const unsigned char *const y_neg_buffer,
        int y_neg_buffer_length,
        const unsigned char *const z_pos_buffer,
        int z_pos_buffer_length,
        const unsigned char *const z_neg_buffer,
        int z_neg_buffer_length,
        int force_channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_load_OGL_single_cubemap_from_memory
    (
        const unsigned char *const buffer,
        int buffer_length,
        const char face_order[6],
        int force_channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_create_OGL_texture
    (
        const unsigned char *const data,
        int width,
        int height,
        int channels,
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

unsigned int
    SOIL_create_OGL_single_cubemap
    (
        const unsigned char *const data,
        int width, int height, int channels,
        const char face_order[6],
        unsigned int reuse_texture_ID,
        unsigned int flags
    );

int
    SOIL_save_screenshot
    (
        const char *filename,
        int image_type,
        int x, int y,
        int width, int height
    );

unsigned char*
    SOIL_load_image
    (
        const char *filename,
        int *width, int *height, int *channels,
        int force_channels
    );

unsigned char*
    SOIL_load_image_from_memory
    (
        const unsigned char *const buffer,
        int buffer_length,
        int *width, int *height, int *channels,
        int force_channels
    );

int
    SOIL_save_image
    (
        const char *filename,
        int image_type,
        int width, int height, int channels,
        const unsigned char *const data
    );

void
    SOIL_free_image_data
    (
        unsigned char *img_data
    );

const char*
    SOIL_last_result
    (
        void
    );

enum
{
   STBI_default = 0, // only used for req_comp

   STBI_grey       = 1,
   STBI_grey_alpha = 2,
   STBI_rgb        = 3,
   STBI_rgb_alpha  = 4,
};

typedef unsigned char stbi_uc;
extern int      stbi_write_bmp       (char const *filename,     int x, int y, int comp, void *data);
extern int      stbi_write_tga       (char const *filename,     int x, int y, int comp, void *data);
extern stbi_uc *stbi_load            (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern stbi_uc *stbi_load_from_memory(stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern float *stbi_loadf            (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern float *stbi_loadf_from_memory(stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern void   stbi_hdr_to_ldr_gamma(float gamma);
extern void   stbi_hdr_to_ldr_scale(float scale);
extern void   stbi_ldr_to_hdr_gamma(float gamma);
extern void   stbi_ldr_to_hdr_scale(float scale);
extern char    *stbi_failure_reason  (void);
extern void     stbi_image_free      (void *retval_from_stbi_load);
extern int      stbi_info_from_memory(stbi_uc const *buffer, int len, int *x, int *y, int *comp);
extern int      stbi_is_hdr_from_memory(stbi_uc const *buffer, int len);
extern int      stbi_info            (char const *filename,     int *x, int *y, int *comp);
extern int      stbi_is_hdr          (char const *filename);
extern char *stbi_zlib_decode_malloc_guesssize(const char *buffer, int len, int initial_size, int *outlen);
extern char *stbi_zlib_decode_malloc(const char *buffer, int len, int *outlen);
extern int   stbi_zlib_decode_buffer(char *obuffer, int olen, const char *ibuffer, int ilen);
extern char *stbi_zlib_decode_noheader_malloc(const char *buffer, int len, int *outlen);
extern int   stbi_zlib_decode_noheader_buffer(char *obuffer, int olen, const char *ibuffer, int ilen);
extern int      stbi_jpeg_test_memory     (stbi_uc const *buffer, int len);
extern stbi_uc *stbi_jpeg_load_from_memory(stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern int      stbi_jpeg_info_from_memory(stbi_uc const *buffer, int len, int *x, int *y, int *comp);
extern stbi_uc *stbi_jpeg_load            (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern int      stbi_jpeg_info            (char const *filename,     int *x, int *y, int *comp);
extern int      stbi_png_test_memory      (stbi_uc const *buffer, int len);
extern stbi_uc *stbi_png_load_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern int      stbi_png_info_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp);
extern stbi_uc *stbi_png_load             (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern int      stbi_png_info             (char const *filename,     int *x, int *y, int *comp);
extern int      stbi_bmp_test_memory      (stbi_uc const *buffer, int len);
extern stbi_uc *stbi_bmp_load             (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern stbi_uc *stbi_bmp_load_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern int      stbi_tga_test_memory      (stbi_uc const *buffer, int len);
extern stbi_uc *stbi_tga_load             (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern stbi_uc *stbi_tga_load_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern int      stbi_psd_test_memory      (stbi_uc const *buffer, int len);
extern stbi_uc *stbi_psd_load             (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern stbi_uc *stbi_psd_load_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern int      stbi_hdr_test_memory      (stbi_uc const *buffer, int len);
extern float *  stbi_hdr_load             (char const *filename,     int *x, int *y, int *comp, int req_comp);
extern float *  stbi_hdr_load_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
extern stbi_uc *stbi_hdr_load_rgbe        (char const *filename,           int *x, int *y, int *comp, int req_comp);
extern float *  stbi_hdr_load_from_memory (stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
typedef struct
{
   int       (*test_memory)(stbi_uc const *buffer, int len);
   stbi_uc * (*load_from_memory)(stbi_uc const *buffer, int len, int *x, int *y, int *comp, int req_comp);
} stbi_loader;
extern int stbi_register_loader(stbi_loader *loader);

typedef unsigned char uint8;

typedef void (*stbi_idct_8x8)(uint8 *out, int out_stride, short data[64], unsigned short *dequantize);
typedef void (*stbi_YCbCr_to_RGB_run)(uint8 *output, uint8 const *y, uint8 const *cb, uint8 const *cr, int count, int step);
extern void stbi_install_idct(stbi_idct_8x8 func);
extern void stbi_install_YCbCr_to_RGB(stbi_YCbCr_to_RGB_run func);
]]

local platform_path = string.format("bin/%s/%s/libsoil.%s", ffi.os, ffi.arch,
                                    jit.os == "OSX" and "dylib" or
                                    jit.os == "Windows" and "dll" or
                                    jit.os == "Linux" and "so")

return ffi.load( platform_path )
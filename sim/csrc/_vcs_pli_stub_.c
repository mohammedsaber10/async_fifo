#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <stdio.h>
#include <dlfcn.h>

#ifdef __cplusplus
extern "C" {
#endif

extern void* VCS_dlsymLookup(const char *);
extern void vcsMsgReportNoSource1(const char *, const char*);

/* PLI routine: $vcdplustblog:check */
#ifndef __VCS_PLI_STUB_vpdlogneeddebug
#define __VCS_PLI_STUB_vpdlogneeddebug
extern void vpdlogneeddebug(int data, int reason);
#pragma weak vpdlogneeddebug
void vpdlogneeddebug(int data, int reason)
{
    static int _vcs_pli_stub_initialized_ = 0;
    static void (*_vcs_pli_fp_)(int data, int reason) = NULL;
    if (!_vcs_pli_stub_initialized_) {
        _vcs_pli_stub_initialized_ = 1;
        _vcs_pli_fp_ = (void (*)(int data, int reason)) dlsym(RTLD_NEXT, "vpdlogneeddebug");
        if (_vcs_pli_fp_ == NULL) {
            _vcs_pli_fp_ = (void (*)(int data, int reason)) VCS_dlsymLookup("vpdlogneeddebug");
        }
    }
    if (_vcs_pli_fp_) {
        _vcs_pli_fp_(data, reason);
    }
}
void (*__vcs_pli_dummy_reference_vpdlogneeddebug)(int data, int reason) = vpdlogneeddebug;
#endif /* __VCS_PLI_STUB_vpdlogneeddebug */

/* PLI routine: $vcdplusmsglog:check */
#ifndef __VCS_PLI_STUB_msglogneeddebug
#define __VCS_PLI_STUB_msglogneeddebug
extern void msglogneeddebug(int data, int reason);
#pragma weak msglogneeddebug
void msglogneeddebug(int data, int reason)
{
    static int _vcs_pli_stub_initialized_ = 0;
    static void (*_vcs_pli_fp_)(int data, int reason) = NULL;
    if (!_vcs_pli_stub_initialized_) {
        _vcs_pli_stub_initialized_ = 1;
        _vcs_pli_fp_ = (void (*)(int data, int reason)) dlsym(RTLD_NEXT, "msglogneeddebug");
        if (_vcs_pli_fp_ == NULL) {
            _vcs_pli_fp_ = (void (*)(int data, int reason)) VCS_dlsymLookup("msglogneeddebug");
        }
    }
    if (_vcs_pli_fp_) {
        _vcs_pli_fp_(data, reason);
    }
}
void (*__vcs_pli_dummy_reference_msglogneeddebug)(int data, int reason) = msglogneeddebug;
#endif /* __VCS_PLI_STUB_msglogneeddebug */

#ifdef __cplusplus
}
#endif

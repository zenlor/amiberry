 /*
  * UAE - The Un*x Amiga Emulator
  *
  * Prototypes for main.c
  *
  * Copyright 1996 Bernd Schmidt
  */

#ifndef UAE_UAE_H
#define UAE_UAE_H

extern void do_start_program (void);
extern void do_leave_program (void);
extern void start_program (void);
extern void leave_program (void);
extern void real_main (int, TCHAR **);
extern void usage (void);
extern void sleep_millis (int ms);
extern void sleep_millis_main (int ms);
extern void sleep_millis_busy (int ms);
extern int sleep_resolution;


extern void uae_reset (int);
extern void uae_quit (void);
extern void uae_restart (int, TCHAR*);
extern void reset_all_systems (void);
extern void target_reset (void);
extern void target_run (void);
extern void target_quit (void);
extern void stripslashes (TCHAR *p);
extern void fixtrailing (TCHAR *p);
extern void getpathpart (TCHAR *outpath, int size, const TCHAR *inpath);
extern void getfilepart (TCHAR *out, int size, const TCHAR *path);

extern int quit_program;

extern TCHAR start_path_data[256];

/* This structure is used to define menus. The val field can hold key
 * shortcuts, or one of these special codes:
 *   -4: deleted entry, not displayed, not selectable, but does count in
 *       select value
 *   -3: end of table
 *   -2: line that is displayed, but not selectable
 *   -1: line that is selectable, but has no keyboard shortcut
 *    0: Menu title
 */
struct bstring {
    const TCHAR *data;
    int val;
};

extern void fetch_saveimagepath (TCHAR*, int, int);
#define uaerand() rand()

#endif //UAE_UAE_H
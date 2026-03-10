#include <R.h>
#include <R_ext/Rdynload.h>

void R_init_faerextendr_extendr(DllInfo *dll);

void R_init_faerextendr(DllInfo *dll) {
    R_init_faerextendr_extendr(dll);
}

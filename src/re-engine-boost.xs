/* re::engine::boost - Perl interface to boost::regex */
#include <boost/regex.hpp>

#include "xshelper.h"

#if PERL_BCDVERSION <= 0x5010000
#error require 5.12.0
#endif

bool const REB_DEBUG = false;

static regexp*
get_rx(REGEXP* const rxsv) {
    dTHX;
    return reinterpret_cast<regexp*>(SvANY(rxsv));
}


static boost::regex*
get_br(regexp* const rx) {
    return reinterpret_cast<boost::regex*>(rx->pprivate);
}

static boost::regex*
get_br(REGEXP* const rxsv) {
    regexp* const rx = get_rx(rxsv);
    return get_br(rx);
}

/* interface */
static REGEXP *
re_comp(pTHX_ SV * const, U32);

static I32
re_exec(pTHX_ REGEXP * const, char *, char *,
                  char *, I32, SV *, void *, U32);

static char*
re_intuit(pTHX_ REGEXP * const, SV *, char *,
                    char *, U32, re_scream_pos_data *);

static SV*
re_checkstr(pTHX_ REGEXP * const);

static void
re_free(pTHX_ REGEXP * const);

static SV*
re_package(pTHX_ REGEXP * const);

#ifdef USE_ITHREADS
static void *
re_dupe(pTHX_ REGEXP * const, CLONE_PARAMS *);
#endif

const regexp_engine engine = {
    re_comp,
    re_exec,
    re_intuit,
    re_checkstr,
    re_free,
    Perl_reg_numbered_buff_fetch,
    Perl_reg_numbered_buff_store,
    Perl_reg_numbered_buff_length,
    Perl_reg_named_buff,
    Perl_reg_named_buff_iter,
    re_package,
#if defined(USE_ITHREADS)
    re_dupe,
#endif
};


/* implementation */

static REGEXP *
re_comp(pTHX_ SV* const pattern, U32 const flags) {
    if(REB_DEBUG) warn("boost::regex comp /%"SVf"/ 0x%x", pattern, (unsigned)flags);

    STRLEN plen;
    const char* const p = SvPV_const(pattern, plen);

    boost::regex::flag_type f = boost::regex::perl
        | boost::regex::newline_alt;
    // TODO: correct flag setting


    REGEXP* const rxsv = reinterpret_cast<REGEXP*>(
                            newSV_type(SVt_REGEXP) );
    regexp* const rx   = get_rx(rxsv);

    boost::regex* const br = new boost::regex(p, plen, f);
    rx->pprivate = reinterpret_cast<void*>(br);

    rx->extflags = flags;
    rx->engine   = &engine;

    rx->pre_prefix = 0;

    RX_WRAPPED(rxsv) = savepvn(p, plen);
    RX_WRAPLEN(rxsv) = plen;

    Newxz(rx->offs, rx->nparens + 1, regexp_paren_pair);

    return rxsv;
}

static I32
re_exec(pTHX_ REGEXP* const rxsv, char *stringarg,
        char* strend, char* strbeg, I32 minend, SV* sv,
        void* data, U32 flags) {
    if(REB_DEBUG) warn("boost::regex exec");

    regexp* const rx             = get_rx(rxsv);
    const boost::regex* const br = get_br(rx);

    if(stringarg > strend) {
        rx->offs[0].start = -1;
        rx->offs[0].end   = -1;
        return false;
    }

    bool const ok = boost::regex_search(
        strbeg, strend,
        *br
    );

    return ok;
}

static char *
re_intuit(pTHX_ REGEXP* const rx, SV* sv, char* strpos,
             char* strend, U32 flags, re_scream_pos_data* data)
{
    if(REB_DEBUG) warn("boost::regex intuit");
	PERL_UNUSED_ARG(rx);
	PERL_UNUSED_ARG(sv);
	PERL_UNUSED_ARG(strpos);
	PERL_UNUSED_ARG(strend);
	PERL_UNUSED_ARG(flags);
	PERL_UNUSED_ARG(data);
    return NULL;
}

static SV*
re_checkstr(pTHX_ REGEXP * const rx) {
    if(REB_DEBUG) warn("boost::regex checkstr");
    PERL_UNUSED_ARG(rx);
    return NULL;
}

static void
re_free(pTHX_ REGEXP* const rxsv) {
    if(REB_DEBUG) warn("boost::regex free");
    regexp* const rx       = get_rx(rxsv);
    boost::regex* const br = get_br(rxsv);

    delete br;
}

static SV*
re_package(pTHX_ REGEXP * const rx) {
    if(REB_DEBUG) warn("boost::regex package");
    PERL_UNUSED_ARG(rx);
    return newSVpvs("re::engine::boost");
}

#ifdef USE_ITHREADS
static void *
re_dupe(pTHX_ REGEXP* const rx, CLONE_PARAMS* params) {
    if(REB_DEBUG) warn("boost::regex dup");
    // TODO
}

#endif

MODULE = re::engine::boost    PACKAGE = re::engine::boost

PROTOTYPES: DISABLE

IV
ENGINE()
CODE:
    RETVAL = PTR2IV(&engine);
OUTPUT:
    RETVAL



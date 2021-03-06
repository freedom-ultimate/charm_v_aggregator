
# user enviorn var: MPICXX and MPICC
# or, use the definition in file $CHARMINC/MPIOPTS
if test -x "$CHARMINC/MPIOPTS"
then
  . $CHARMINC/MPIOPTS
else
  MPICXX_DEF=mpicxx
  MPICC_DEF=mpicc
fi

test -z "$MPICXX" && MPICXX=$MPICXX_DEF
test -z "$MPICC" && MPICC=$MPICC_DEF
test "$MPICXX" != "$MPICXX_DEF" && /bin/rm -f $CHARMINC/MPIOPTS
if test ! -f "$CHARMINC/MPIOPTS"
then
  echo MPICXX_DEF=$MPICXX > $CHARMINC/MPIOPTS
  echo MPICC_DEF=$MPICC >> $CHARMINC/MPIOPTS
  chmod +x $CHARMINC/MPIOPTS
fi

CMK_GCC64="-m64 -fPIC"

CMK_REAL_COMPILER=`$MPICXX -show 2>/dev/null | cut -d' ' -f1 `
case "$CMK_REAL_COMPILER" in
g++) CMK_AMD64_CC="$CMK_GCC64"; CMK_AMD64_CXX="$CMK_GCC64" ;;
pgCC)  CMK_AMD64_CC="-fPIC"; CMK_AMD64_CXX="-fPIC -DCMK_FIND_FIRST_OF_PREDICATE=1 --no_using_std " ;;
charmc)  echo "Error> charmc can not call AMPI's mpicxx/mpiCC wrapper! Please fix your PATH."; exit 1 ;;
esac

CMK_CPP_CHARM="/lib/cpp -P"
CMK_CPP_C="$MPICC -E"
CMK_CC="$MPICC $CMK_AMD64_CC "
CMK_CXX="$MPICXX $CMK_AMD64_CXX "
CMK_CXXPP="$MPICXX -E $CMK_AMD64_CXX "

#CMK_SYSLIBS="-lmpich"
CMK_LIBS="-lckqt $CMK_SYSLIBS "
CMK_LD_LIBRARY_PATH="-Wl,-rpath,$CHARMLIBSO/"

CMK_NATIVE_CC="gcc $CMK_GCC64 "
CMK_NATIVE_LD="gcc $CMK_GCC64 "
CMK_NATIVE_CXX="g++ $CMK_GCC64 "
CMK_NATIVE_LDXX="g++ $CMK_GCC64 "
CMK_NATIVE_LIBS=""

# fortran compiler 
CMK_CF90=`which f95 2>/dev/null`
if test -n "$CMK_CF90"
then
#    CMK_FPP="/lib/cpp -P -CC"
#    CMK_CF90="$CMK_CF90 -fpic -fautomatic -fdollar-ok "
#    CMK_CF90_FIXED="$CMK_CF90 -ffixed-form "
#    CMK_F90LIBS="-lgfortran "
#    CMK_F90_USE_MODDIR=1
#    CMK_F90_MODINC="-I"
#    CMK_MOD_NAME_ALLCAPS=
#    CMK_MOD_EXT="mod"
    . $CHARMINC/conv-mach-gfortran.sh
else
    CMK_CF77="g77 "
    CMK_CF90="f90 "
    CMK_CF90_FIXED="$CMK_CF90 -W132 "
    CMK_F90LIBS="-L/usr/absoft/lib -L/opt/absoft/lib -lf90math -lfio -lU77 -lf77math "
    CMK_F77LIBS="-lg2c "
    CMK_F90_USE_MODDIR=1
    CMK_F90_MODINC="-p"
fi

CMK_QT='generic64-light'
CMK_RANLIB="ranlib"


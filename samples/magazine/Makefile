ROOTDIR = $(abspath $(dir $(firstword $(MAKEFILE_LIST))))
DEPDIR = ../..
SRCDIR = .
INCDIR = .
BLDDIR = obj
OUTDIR = .

CXXFLAGS = $(NULL)
CFLAGS = $(NULL)
DFLAGS = $(NULL)

BLAS = 1
SYM = 1
OMP = 0

# explore AVX/ARCH=native
SSE = 0

# include common Makefile artifacts
include $(DEPDIR)/Makefile.inc

# necessary include directories
IFLAGS += -I$(call quote,$(INCDIR))
IFLAGS += -I$(call quote,$(DEPDIR)/include)

OUTNAME := $(shell basename "$(ROOTDIR)")
HEADERS := $(wildcard $(INCDIR)/*.h) $(wildcard $(INCDIR)/*.hpp) $(wildcard $(INCDIR)/*.hxx) $(wildcard $(INCDIR)/*.hh) \
           $(wildcard $(SRCDIR)/*.h) $(wildcard $(SRCDIR)/*.hpp) $(wildcard $(SRCDIR)/*.hxx) $(wildcard $(SRCDIR)/*.hh) \
           $(DEPDIR)/include/libxsmm_source.h
CPPSRCS := $(wildcard $(SRCDIR)/*.cpp)
CXXSRCS := $(wildcard $(SRCDIR)/*.cxx)
CCXSRCS := $(wildcard $(SRCDIR)/*.cc)
CSOURCS := $(wildcard $(SRCDIR)/*.c)
CPPOBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(CPPSRCS:.cpp=-cpp.o)))
CXXOBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(CXXSRCS:.cxx=-cxx.o)))
CCXOBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(CCXSRCS:.cc=-cc.o)))
COBJCTS := $(patsubst %,$(BLDDIR)/%,$(notdir $(CSOURCS:.c=-c.o)))
ifneq (,$(strip $(FC)))
FXXSRCS := $(wildcard $(SRCDIR)/*.f)
F77SRCS := $(wildcard $(SRCDIR)/*.F)
F90SRCS := $(wildcard $(SRCDIR)/*.f90) $(wildcard $(SRCDIR)/*.F90)
FXXOBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(FXXSRCS:.f=-f.o)))
F77OBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(F77SRCS:.F=-f77.o)))
F90OBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(F90SRCS:.f90=-f90.o)))
F90OBJS := $(patsubst %,$(BLDDIR)/%,$(notdir $(F90OBJS:.F90=-f90.o)))
endif
SOURCES := $(CPPSRCS) $(CXXSRCS) $(CCXSRCS) $(CSOURCS)
OBJECTS := $(CPPOBJS) $(CXXOBJS) $(CCXOBJS) $(COBJCTS)
FTNSRCS := $(FXXSRCS) $(F77SRCS) $(F90SRCS)
MODULES := $(addsuffix .mod,$(basename $(FTNSRCS)))
FTNOBJS := $(FXXOBJS) $(F77OBJS) $(F90OBJS)
XFILES := $(OUTDIR)/$(OUTNAME)_xsmm $(OUTDIR)/$(OUTNAME)_batch \
          $(OUTDIR)/$(OUTNAME)_blas \
          $(OUTDIR)/$(OUTNAME)_blaze \
          $(OUTDIR)/$(OUTNAME)_eigen

ifneq (0,$(BLAZE))
ifeq (,$(strip $(BLAZEROOT)))
  ifneq (,$(wildcard $(DEPDIR)/../blaze*/blaze/Blaze.h))
    BLAZEROOT = $(lastword $(sort $(wildcard $(DEPDIR)/../blaze*)))
  else ifneq (,$(wildcard $(HOME)/blaze*/blaze/Blaze.h))
    BLAZEROOT = $(lastword $(sort $(wildcard $(HOME)/blaze*)))
  endif
endif
endif

ifneq (,$(BLAZEROOT))
  DFLAGS += -D__BLAZE
  IFLAGS += -I$(call quote,$(BLAZEROOT))
  BLAZE ?= 1
  DFLAGS += -DBLAZE_USE_SHARED_MEMORY_PARALLELIZATION=$(shell echo "$$(($(BLAZE)-1))")
else
  BLAZE := 0
endif

ifneq (0,$(EIGEN))
ifeq (,$(strip $(EIGENROOT)))
  ifneq (,$(wildcard $(DEPDIR)/../eigen*/Eigen/Dense))
    EIGENROOT = $(lastword $(sort $(wildcard $(DEPDIR)/../eigen*)))
  else ifneq (,$(wildcard $(HOME)/eigen*/Eigen/Dense))
    EIGENROOT = $(lastword $(sort $(wildcard $(HOME)/eigen*)))
  else ifneq (,$(wildcard /usr/include/eigen3/Eigen/Dense))
    EIGENROOT = /usr/include/eigen3
  else ifneq (,$(wildcard /usr/local/opt/eigen/include/eigen3/Eigen/Dense))
    EIGENROOT = /usr/local/opt/eigen/include/eigen3
  endif
endif
endif

ifneq (,$(EIGENROOT))
  DFLAGS += -D__EIGEN
  IFLAGS += -I$(call quote,$(EIGENROOT))
  EIGEN ?= 1
  #ifneq (0,$(MKL))
    #DFLAGS += -DEIGEN_USE_MKL_ALL
  #endif
  ifneq (0,$(shell echo "$$((1 < $(BLAS) || 1 < $(EIGEN)))"))
    DFLAGS += -DEIGEN_USE_THREADS
  else
    DFLAGS += -DEIGEN_DONT_PARALLELIZE
  endif
  ifneq (,$(wildcard $(EIGENROOT)/unsupported/Eigen/CXX11/ThreadPool))
    DFLAGS += -D__EIGEN_UNSUPPORTED
  endif
else
  EIGEN := 0
endif

.PHONY: all
all: $(XFILES)

.PHONY: compile
compile: $(OBJECTS) $(FTNOBJS)

$(OUTDIR)/$(OUTNAME)_xsmm: $(OUTDIR)/.make $(BLDDIR)/$(OUTNAME)_xsmm-c.o $(EXTDEP)
	$(LD) -o $@ $(BLDDIR)/$(OUTNAME)_xsmm-c.o $(call cleanld,$(EXTLIB) $(SLDFLAGS) $(LDFLAGS) $(CLDFLAGS))

$(OUTDIR)/$(OUTNAME)_batch: $(OUTDIR)/.make $(BLDDIR)/$(OUTNAME)_batch-c.o $(EXTDEP)
	$(LD) -o $@ $(BLDDIR)/$(OUTNAME)_batch-c.o $(call cleanld,$(EXTLIB) $(SLDFLAGS) $(LDFLAGS) $(CLDFLAGS))

$(OUTDIR)/$(OUTNAME)_blas: $(OUTDIR)/.make $(BLDDIR)/$(OUTNAME)_blas-c.o
	$(LD) -o $@ $(BLDDIR)/$(OUTNAME)_blas-c.o $(call cleanld,$(SLDFLAGS) $(LDFLAGS) $(CLDFLAGS))

ifneq (,$(BLAZEROOT))
$(OUTDIR)/$(OUTNAME)_blaze: $(OUTDIR)/.make $(BLDDIR)/$(OUTNAME)_blaze-cpp.o
	$(LD) -o $@ $(BLDDIR)/$(OUTNAME)_blaze-cpp.o $(call cleanld,$(SLDFLAGS) $(LDFLAGS) $(CLDFLAGS))
else
.PHONY: $(OUTDIR)/$(OUTNAME)_blaze
endif

ifneq (,$(EIGENROOT))
$(OUTDIR)/$(OUTNAME)_eigen: $(OUTDIR)/.make $(BLDDIR)/$(OUTNAME)_eigen-cpp.o
	$(LD) -o $@ $(BLDDIR)/$(OUTNAME)_eigen-cpp.o $(call cleanld,$(SLDFLAGS) $(LDFLAGS) $(CLDFLAGS))
else
.PHONY: $(OUTDIR)/$(OUTNAME)_eigen
endif

$(BLDDIR)/%-cpp.o: $(SRCDIR)/%.cpp .state $(BLDDIR)/.make $(HEADERS) Makefile $(DEPDIR)/Makefile.inc
	$(CXX) $(DFLAGS) $(IFLAGS) $(CXXFLAGS) $(CTARGET) -c $< -o $@

$(BLDDIR)/%-c.o: $(SRCDIR)/%.c .state $(BLDDIR)/.make $(HEADERS) Makefile $(DEPDIR)/Makefile.inc
	$(CC) $(DFLAGS) $(IFLAGS) $(CFLAGS) $(CTARGET) -c $< -o $@

$(BLDDIR)/%-f.o: $(SRCDIR)/%.f .state $(BLDDIR)/.make Makefile $(DEPDIR)/Makefile.inc
	$(FC) $(FCMTFLAGS) $(DFLAGS) $(IFLAGS) $(FCFLAGS) $(FTARGET) -c $< -o $@

$(BLDDIR)/%-f90.o: $(SRCDIR)/%.f90 .state $(BLDDIR)/.make Makefile $(DEPDIR)/Makefile.inc
	$(FC) $(FCMTFLAGS) $(DFLAGS) $(IFLAGS) $(FCFLAGS) $(FTARGET) -c $< -o $@

$(BLDDIR)/%-f90.o: $(SRCDIR)/%.F90 .state $(BLDDIR)/.make Makefile $(DEPDIR)/Makefile.inc
	$(FC) $(FCMTFLAGS) $(DFLAGS) $(IFLAGS) $(FCFLAGS) $(FTARGET) -c $< -o $@

$(BLDDIR)/%-f77.o: $(SRCDIR)/%.F .state $(BLDDIR)/.make Makefile $(DEPDIR)/Makefile.inc
	$(FC) $(FCMTFLAGS) $(DFLAGS) $(IFLAGS) $(FCFLAGS) $(FTARGET) -c $< -o $@

.PHONY: clean
clean:
ifneq ($(call qapath,$(BLDDIR)),$(ROOTDIR))
ifneq ($(call qapath,$(BLDDIR)),$(call qapath,.))
	@-rm -rf $(BLDDIR)
endif
endif
ifneq (,$(wildcard $(BLDDIR))) # still exists
	@-rm -f $(OBJECTS) $(OBJECTX) $(FTNOBJS) $(FTNOBJX) *__genmod.* *.dat *.log
	@-rm -f $(BLDDIR)/*.gcno $(BLDDIR)/*.gcda $(BLDDIR)/*.gcov
endif

.PHONY: realclean
realclean: clean
ifneq ($(call qapath,$(OUTDIR)),$(ROOTDIR))
ifneq ($(call qapath,$(OUTDIR)),$(call qapath,.))
	@-rm -rf $(OUTDIR)
endif
endif
ifneq (,$(wildcard $(OUTDIR))) # still exists
	@-rm -f $(OUTDIR)/libxsmm.$(DLIBEXT) $(OUTDIR)/*.stackdump
	@-rm -f $(XFILES) $(MODULES)
endif

.PHONY: deepclean
deepclean: realclean
	@-rm -f .make .state

#!/usr/bin/env bash

TESTFILE1=$(mktemp)

if [ -x "$(command -v python3)" ]; then
  PYTHON=$(command -v python3)
else
  PYTHON=$(command -v python)
fi

${PYTHON} << END
import random as rnd
import time as time
rnd.seed(time.time())
randnum = rnd.sample(range(1,101), SAMPLESIZE)
f1 = open("${TESTFILE1}", "w+")
for m in randnum:
    for n in randnum:
        line = str(m) + '_' + str(n) + '_' \
             + str(m) + '_' + str(m) + '\n'
        f1.write(line)
f1.close()
END

NUMPREC=X
GS_OP=X

for i in `cat ${TESTFILE1}`
do
  M=`echo ${i} | awk -F"_" '{print $1}'`
  N=`echo ${i} | awk -F"_" '{print $2}'`
  LDI=`echo ${i} | awk -F"_" '{print $3}'`
  LDO=`echo ${i} | awk -F"_" '{print $4}'`
  echo ${M} ${N} ${LDI} ${LDI}
  for ROWSCOLSOFFS in 0 1 2
  do
    for IDXTYPE in 0 1
    do
      ${BIN_INSTR_TOOL} ./eltwise_unary_gather_scatter ${M} ${N} ${LDI} ${LDO} ${GS_OP} ${ROWSCOLSOFFS} ${NUMPREC} ${IDXTYPE} 1
    done
  done
done

rm ${TESTFILE1}

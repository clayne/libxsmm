#!/usr/bin/env bash

if [ -x "$(command -v python3)" ]; then
  PYTHON=$(command -v python3)
else
  PYTHON=$(command -v python)
fi

TESTFILE1=$(mktemp)

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

TERNARY_OP=0
PREC=0
RMODE=0

for i in $(cat ${TESTFILE1}); do
  M=$(echo ${i} | awk -F"_" '{print $1}')
  N=$(echo ${i} | awk -F"_" '{print $2}')
  LDI=$(echo ${i} | awk -F"_" '{print $3}')
  LDO=$(echo ${i} | awk -F"_" '{print $4}')
  echo ${M} ${N} ${LDI} ${LDO}
  PREC_IN0=$(echo ${PREC} | awk -F"_" '{print $1}')
  PREC_IN1=$(echo ${PREC} | awk -F"_" '{print $2}')
  PREC_IN2=$(echo ${PREC} | awk -F"_" '{print $3}')
  PREC_OUT=$(echo ${PREC} | awk -F"_" '{print $4}')
  PREC_COMP=$(echo ${PREC} | awk -F"_" '{print $5}')
  for BCAST in 0 1 2 3 4 5 6; do
    ${BIN_INSTR_TOOL} ./eltwise_ternary_simple ${TERNARY_OP} ${BCAST} ${PREC_IN0} ${PREC_IN1} ${PREC_IN2} ${PREC_COMP} ${PREC_OUT} ${M} ${N} ${LDI} ${LDO} ${RMODE}
  done
done

rm ${TESTFILE1}

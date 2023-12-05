rm -f ./*.v
rm -f cpu

cp ../code/**/*.v ./
iverilog -o cpu ./*.v

cp ./testcases/instruction_1.txt instruction.txt
vvp cpu >/dev/null
diff ./testcases/output_1.txt output.txt >/dev/null
error=$?
if [ $error -eq 0 ]; then
   echo "test1 pass."
elif [ $error -eq 1 ]; then
   diff ./testcases/output_1.txt output.txt
   echo "test1 failed."
   exit -1
else
   echo "error"
   exit -1
fi

cp ./testcases/instruction_2.txt instruction.txt
vvp cpu >/dev/null
diff ./testcases/output_2.txt output.txt >/dev/null
error=$?
if [ $error -eq 0 ]; then
   echo "test2 pass."
elif [ $error -eq 1 ]; then
   diff ./testcases/output_2.txt output.txt
   echo "test2 failed."
   exit -1
else
   echo "error"
   exit -1
fi

cp ./testcases/instruction_3.txt instruction.txt
vvp cpu >/dev/null
diff ./testcases/output_3.txt output.txt >/dev/null
error=$?
if [ $error -eq 0 ]; then
   echo "test3 pass."
elif [ $error -eq 1 ]; then
   diff ./testcases/output_3.txt output.txt
   echo "test3 failed."
   exit -1
else
   echo "error"
   exit -1
fi

cp ./testcases/instruction_4.txt instruction.txt
vvp cpu >/dev/null
diff ./testcases/output_4.txt output.txt >/dev/null
error=$?
if [ $error -eq 0 ]; then
   echo "test4 pass."
elif [ $error -eq 1 ]; then
   diff ./testcases/output_4.txt output.txt
   echo "test4 failed."
   exit -1
else
   echo "error"
   exit -1
fi

rm -f ./*.v
rm -f cpu
rm instruction.txt
rm output.txt
rm waveform.vcd
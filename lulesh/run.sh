

BASIC="mpiexec -n 8 ./lulesh2.0 -s "

for INPUT_SIZE in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
    $BASIC $INPUT_SIZE
done


for i in */;
do
  mol=${i%/};
  charge=$(grep $mol charge_multi.dat | awk '{print $2}' ) ;
  echo $mol $charge ;
  for cand in $mol/??-* ;
  do
    prelabel=${cand//$mol/}
    label=${prelabel: 1:2}
    radical=$( grep "^$label" $mol/radicals.dat | awk '{print $2}' )
    sbatch --partition=cpu-single -J ${mol:0:1}${mol:4:1}$label \
      $(myutils gval_workflow -path) -d $cand  -f "g${radical}d3" -c $charge
  done
done
#!/bin/bash

mapfile -t all_xyzs < <( find . -name '*.xyz' )

for cand in ${all_xyzs[@]}
do
  prename_mol=${cand#./}
  name_mol=${prename_mol%%/*}
  echo 00 > ${name_mol}.del
done
for cand in ${all_xyzs[@]}
do
  prename_mol=${cand#./}
  name_mol=${prename_mol%%/*}

  if [[ "$cand" == *"reactant"* ]]
  then
    mkdir $name_mol/opt
    mv $cand $name_mol/opt/opt.xyz
    cp $name_mol/opt/opt.xyz $name_mol/opt/model.xyz
  elif [[ "$cand" == *"/opt/"* ]] || [[ "$cand" == *"${name_mol}/"??"-"* ]]
  then
    continue
  else
    prename=${cand##*/}
    name=${prename%.xyz}
    n=$(cat ${name_mol}.del)
    n=$((10#$n))
    i=$(( n + 1 ))
    i=$( printf "%02d\n" $i )
    mkdir $name_mol/$i-$name
    cp $cand $name_mol/$i-$name/model.xyz
    echo rm -r ${cand%/*}
    printf "%02d\n" $((10#$i)) > ${name_mol}.del
  fi

done

for cand in ${all_xyzs[@]}
do
  prename_mol=${cand#./}
  name_mol=${prename_mol%%/*}
  rm ${name_mol}.del
  rm -r ${name_mol}/reactant
  rm -r ${name_mol}/radicals
done

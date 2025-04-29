# script to create the readme file. Execute it in the directory that contains
# the possible molecules. Be sure that molecule.png, gvalues.png and
# gvalues_table.md exist in the directory of the candidates.


cat <<EOF
# PolyGlu \& PolyLys

This data corresponds to the theoretical prediction of g-values of Glutamine
and Lysine (charged and uncharged). This data is meant to be compared to
epr-spectrum obtained from polyGlu and polyLys sintetized peptides.

EOF

candidates=( Glu_uncharged  Glu_charged Lys_charged Lys_uncharged )

for cand in ${candidates[@]}
do
  cat <<EOF

## $cand

<div style="display: flex;">
  <img src="$cand/molecule.png" alt="Image 1" width="50%">
</div>

<div style="display: flex;">
  <img src="$cand/gvalues.png" alt="Image 1" width="50%">
</div>

EOF

cat $cand/gvalues_table.md
echo ; echo
done

cat <<EOF
# Fitting with the best candidates

Given that the set of candidates could be large, this section filters the
candidates to those that contribute to the fitting with a minimum of the 5
percent. It also shows the percentage per candidates in tables.

EOF

mkdir best_fit_images
# =============================================================================
echo "## Best fit"
# Search spectrums files
mapfile -t all_fields < <(find . -name 'spectrum_wo_hyFiCorr.dat')


myutils best_fit './experiments/field_intensity.dat' \
   './best_fit_images/fit2exper1.png' '' ${all_fields[@]} > delete_tmp.txt

cat <<EOF

<div style="display: flex;">
  <img src="/best_fit_images/fit2exper1.png" alt="Image 1" width="50%">
</div>

EOF

sed -i "s/spectrum_wo_hyFiCorr.dat/vmd_image.md/g" delete_tmp.txt
mapfile -t names < <( awk '{print $1}' delete_tmp.txt )
mapfile -t percentages < <( awk '{print $3}' delete_tmp.txt )

echo "| System | Percentage |"
echo "|--------|------------|"

for (( i=0; i<${#names[@]} ; i++ ));
do
  red_name=${names[ $i ]//\.\//};
  red_name=${red_name//\/vmd_image.md/}
  name=${names[$i]}
  echo "| [ $red_name ]($name) | ${percentages[$i]} |"
done

rm delete_tmp.txt

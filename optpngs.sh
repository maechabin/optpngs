#!/bin/bash

[ -z $1 ] && dir="." || dir=${1}

old_pngs_dir=${dir}/old_pngs
if [ ! -e ${old_pngs_dir} ]; then
  mkdir ${old_pngs_dir}
fi

list=`find ${dir} -maxdepth 1 -type f -name '*.png'`
for file in ${list[@]}; do
  file_name="${file##*/}"
  file_size=`wc -c ${file} | awk '{print $1}'`
  cp ${file} ${old_pngs_dir}/${file_name}

  pngquant --ext .png --force --speed 1 --quality=65-80 ${file}

  optimized_size=`wc -c ${file} | awk '{print $1}'`
  optimized_rate=`echo "scale=2; $optimized_size / $file_size * 100" | bc`

  echo "${file}  ${file_size} Bytes ===> ${optimized_size} Bytes (${optimized_rate})"
done
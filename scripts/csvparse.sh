#!/usr/bin/env bash

echo 'id: "Read_count_Vs_RIN"
section_name: "Scatter Analysis"
description: "This plot shows the relationship between Read count and RIN score."
plot_type: "scatter"
pconfig:
  id: "countRIN_scatter_plot"
  title: "Read count Vs RIN"
  xlab: "Read_count"
  ylab: "RIN"
data:' >> Read_count_Vs_RIN.yml

cat metadata.csv | while read -r line
  do
    IFS=',' read -r -a array <<< $line;
    echo -n -e ${array[1]} ': { x:' ${array[4]}', y:' ${array[2]} '}' >> Read_count_Vs_RIN.yml
    echo '' >> Read_count_Vs_RIN.yml
  done
 sed -i '/WGP_Name/d' Read_count_Vs_RIN.yml
 
 
echo 'id: "Read_count_Vs_Conc_ngul"
section_name: "Scatter Analysis"
description: "This plot shows the relationship between Read count and Conc_ngul score."
plot_type: "scatter"
pconfig:
  id: "countConc_ngul_scatter_plot"
  title: "Read count Vs Conc_ngul"
  xlab: "Read_count"
  ylab: "Conc_ngul"
data:' >> Read_count_Vs_Conc_ngul.yml

cat metadata.csv | while read -r line
  do
    IFS=',' read -r -a array <<< $line;
    echo -n -e ${array[1]} ': { x:' ${array[4]}', y:' ${array[3]} '}' >> Read_count_Vs_Conc_ngul.yml
    echo '' >> Read_count_Vs_Conc_ngul.yml
  done
 sed -i '/WGP_Name/d' Read_count_Vs_Conc_ngul.yml
 
  

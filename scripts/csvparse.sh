#!/usr/bin/env bash

# remove old versions

[ -e file ] && rm Q30.txt readcount.txt GC.txt

# make column for readcounts from all fastp json reports
DELIMITER=","

printf 'reads' >> readcount.txt
echo '' >> readcount.txt

for i in $(cut -f 2 -d "${DELIMITER}" metadata.csv );
do
        if grep -m 1 "total_reads" ${i}.json; then
                grep -m 1 "total_reads" ${i}.json >> readcount.txt
        else
                echo "0" >> readcount.txt
        fi
        sed -i 's/      //g' readcount.txt
        sed -i 's/"total_reads"://g' readcount.txt
        sed -i 's/,//g' readcount.txt
done


# make column for Q30 from all fastp json reports
DELIMITER=","

printf 'Q30' >> Q30.txt
echo '' >> Q30.txt

for i in $(cut -f 2 -d "${DELIMITER}" metadata.csv );
do
        if grep -m 1 "q30_rate" ${i}.json; then
                grep -m 1 "q30_rate" ${i}.json >> Q30.txt
        else
                echo "0" >> Q30.txt
        fi
        sed -i 's/      //g' Q30.txt
        sed -i 's/"q30_rate"://g' Q30.txt
        sed -i 's/,//g' Q30.txt
done

# make column for GC from all fastp json reports
DELIMITER=","

printf 'GC' >> GC.txt
echo '' >> GC.txt

for i in $(cut -f 2 -d "${DELIMITER}" metadata.csv );
do
        if grep -m 1 "gc_content" ${i}.json; then
                grep -m 1 "gc_content" ${i}.json >> GC.txt
        else
                echo "0" >> GC.txt
        fi
        sed -i 's/      //g' GC.txt
        sed -i 's/"gc_content"://g' GC.txt
        sed -i 's/,//g' GC.txt
done


#add to metadata.csv
awk -F, '{getline f1 <"readcount.txt" ; getline f2 <"Q30.txt" ; getline f3 <"GC.txt" ; print $1,$2,$3,$4,f1,f2,f3}' OFS=, metadata.csv >> tmp.csv



#remove temp files
rm Q30.txt readcount.txt GC.txt


#make the read_count_Vs_RIN yml
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
 
#make the read_count_Vs_Cong_ngul
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
 
#make the next one and the next...tbc once discussed with others



#move tmp.csv to output
mv tmp.csv outmetadta.csv

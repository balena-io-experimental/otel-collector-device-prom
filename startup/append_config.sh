#!/bin/sh

# Appends one OTel collector config file (next-file) to another (base-file),
# section by section. In other words, the final config file must have a single
# "receivers" section followed by a single "processors" section. So, this script
# works section by section, and appends the relevant section from next-file into
# base-file.
#
# Both files must contain these sections names, at the beginning of a line.
# We assume for now that the service section includes only pipelines.
#
# receivers:
# proecessors:
# exporters:
# sevice:
#   pipelines:
#
# -------------------
# Parameters:
#   $1 -- base-file, must exist
#   $2 -- next-file, must exist
#   $3 -- out-file: name of the output file

base_file="${1}"
next_file="${2}"
out_file="${3}"

# Append the content of a section from a source file to the ouput config file.
#
# $1 -- source file
# $2 -- title of section
# $3 -- title of next section; "EOF" is a sentinel value that specifies copy
#         to end of file
function append_section() {
    source_file="${1}"
    sec_title="${2}:"
    next_title="${3}:"
    #echo "sec_title: ${sec_title}; next_title: ${next_title}"
    # Document source of 
    echo "# From ${source_file}" >>${out_file}

    # Find line number of section
    sec_num=`awk -v sec_line="^${sec_title}" '$0~sec_line {print NR}' ${source_file}`
    if [[ "${next_title}" = "EOF:" ]]; then
        # Copy to end of file
        #echo "sec_num: ${sec_num}"
        awk -v sec_num=${sec_num} 'NR>sec_num' ${source_file} >>${out_file}
    else
        # Find line number of next section
        next_num=`awk -v next_line="^${next_title}" '$0~next_line {print NR}' ${source_file}`
        #echo "sec_num: ${sec_num}; next_num: ${next_num}"
        # Copy to next section
        awk -v sec_num=${sec_num} -v next_num=${next_num} 'NR>sec_num && NR<next_num' ${source_file} >>${out_file}
    fi
}

echo "# ${out_file} generated on startup" >${out_file}
echo "receivers:" >>${out_file}
append_section ${base_file} receivers processors
append_section ${next_file} receivers processors

echo "processors:" >>${out_file}
append_section ${base_file} processors exporters
append_section ${next_file} processors exporters

echo "exporters:" >>${out_file}
append_section ${base_file} exporters service
append_section ${next_file} exporters service

echo "service:" >>${out_file}
echo "  pipelines:" >>${out_file}
append_section ${base_file} "  pipelines" "EOF"
append_section ${next_file} "  pipelines" "EOF"

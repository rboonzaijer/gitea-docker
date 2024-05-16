# This will fetch all tags from docker hub
# Usage: ./fetch-tags.sh

# namespace/repository:tag
namespace=gitea
repository=gitea

file=tags_${namespace}_${repository}_all.txt
file_clean=tags_${namespace}_${repository}_clean.txt

rm -f $file
rm -f $file_clean

for page in {1..20}
do
    echo "fetching tags: ${namespace}/${repository} (page $page)"

    url="https://hub.docker.com/v2/namespaces/$namespace/repositories/$repository/tags?page_size=100&page=$page"

    # stop when a 404 is found
    result=`wget -q -O- $url` || break;
    
    echo $result | grep -o '"name": *"[^"]*' | grep -o '[^"]*$' >> $file

    #sleep 1 # give the poor api a rest...
done

cat $file | grep -Po '^\d{1,}\.\d{1,}\.\d{1,}$' > $file_clean

echo 'done'

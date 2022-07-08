declare -a ROS_VERSIONS=( "foxy" "galactic" "humble" "rolling" )

ORGANIZATION="facebook"
declare -a MODEL_VERSIONS=( "deit-base-patch16-224", "deit-tiny-patch16-224", 
"deit-base-distilled-patch16-224", "deit-small-patch16-224", 
"deit-tiny-distilled-patch16-224", "deit-base-distilled-patch16-384", "deit-small-distilled-patch16-224" )

for VERSION in "${ROS_VERSIONS[@]}"
do
  for MODEL_VERSION in "${MODEL_VERSIONS[@]}"
  do
    ROS_VERSION="$VERSION"
    gcloud builds submit --config cloudbuild.yaml . --substitutions=_ROS_VERSION="$ROS_VERSION",_MODEL_VERSION="$MODEL_VERSION",_ORGANIZATION="$ORGANIZATION" --timeout=10000 &
    pids+=($!)
    echo Dispached "$MODEL_VERSION" on ROS "$ROS_VERSION"
  done
done

for pid in ${pids[*]}; do
  wait "$pid"
done

echo "All builds finished"

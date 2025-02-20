ALG=nn
NN_TYPE=microsoft

LOSS_FUNC=$1
DECAY=$2
LR=$3
MAX_EPOCHS=$4
HEURISTIC_FEATS=$5
FLOW_FEATS=$6
PRED_FEATS=$7
JOIN_FEATS=$8
TABLE_FEATS=$9

NORM_FLOW_LOSS=0

QUERY_MB_SIZE=4
PRIORITY=0.0
PR_NORM=no
SAMPLE_BITMAP_BUCKETS=1000
SAMPLE_BITMAP=0
PRELOAD_FEATURES=1
NUM_MSE_ANCHORING=0
#FLOW_FEATS=1
SWITCH_EPOCH=100000
REL_ESTS=1
ONEHOT=1

USE_VAL_SET=1
WEIGHTED_MSES=(0.0)
EVAL_ON_JOB=1
EVAL_ON_JOBM=0

EVAL_EPOCH=100

LOSSES=join-loss,qerr
COST_MODEL=nested_loop_index7

NHL=4
#RES_DIR=all_results/vldb/default/sample_bitmaps
#RES_DIR=all_results/vldb/default/fcnn_subq_imp
RES_DIR=all_results/vldb/default/fcnn_ablation

BUCKETS=10
HLS=512
LOAD_QUERY_TOGTHER=0
#BUCKETS=10
#HLS=(512)
#DECAYS=(0.1)
#MIN_QERRS=(2.0 4.0 8.0 16.0 32.0 64.0)
NUM_PAR=16

for i in "${!WEIGHTED_MSES[@]}";
  do
  CMD="time python3 main.py --algs nn -n -1 \
   --hidden_layer_size $HLS \
   --use_val_set $USE_VAL_SET \
   --query_mb_size $QUERY_MB_SIZE \
   --weighted_mse ${WEIGHTED_MSES[$i]} \
   --num_mse_anchoring $NUM_MSE_ANCHORING \
   --num_hidden_layers $NHL \
   --max_discrete_featurizing_buckets $BUCKETS \
   --sampling_priority_alpha $PRIORITY \
   --priority_normalize_type $PR_NORM \
   --weight_decay $DECAY \
   --alg $ALG \
   --load_query_together $LOAD_QUERY_TOGTHER \
   --job_skip_zero_queries 0 \
   --losses $LOSSES
   --loss_func $LOSS_FUNC \
   --nn_type $NN_TYPE \
   --sample_bitmap $SAMPLE_BITMAP \
   --sample_bitmap_buckets $SAMPLE_BITMAP_BUCKETS \
   --preload_features $PRELOAD_FEATURES \
   --test_size 0.5 \
   --exp_prefix final_runs \
   --result_dir $RES_DIR \
   --max_epochs $MAX_EPOCHS --cost_model $COST_MODEL \
   --switch_loss_fn_epoch $SWITCH_EPOCH \
   --eval_epoch $EVAL_EPOCH --join_loss_pool_num $NUM_PAR \
   --optimizer_name adamw \
   --normalize_flow_loss $NORM_FLOW_LOSS \
   --eval_on_job $EVAL_ON_JOB \
   --eval_on_jobm $EVAL_ON_JOBM \
   --add_job_features $EVAL_ON_JOB \
   --feat_rel_pg_ests  $REL_ESTS \
   --feat_rel_pg_ests_onehot  $ONEHOT \
   --feat_pg_est_one_hot  $ONEHOT \
   --heuristic_features $HEURISTIC_FEATS \
   --table_features $TABLE_FEATS \
   --pred_features $PRED_FEATS \
   --join_features $JOIN_FEATS \
   --flow_features $FLOW_FEATS --feat_tolerance 0 \
   --lr $LR"
    echo $CMD
    eval $CMD
done

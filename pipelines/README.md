# Tektoncd

Please make a copy from pipelineresource.yaml.sample and pipelinerun.yaml.sample to pipelineresource.yaml and pipelinerun.yaml appropriately and add your parameters.

You can deploy your pipeline in the following order:
```
kubectl apply -f pipelineresource.yaml
kubectl apply -f task.yaml
kubectl apply -f pipeline.yaml
kubectl apply -f pipelinerun.yaml
```

When the pipelinerun.yaml is successfully deployed on the cluster a pod with several sidecars will be scheduled in the `tekton-pipelines` namespace where you can debug the pipeline state.

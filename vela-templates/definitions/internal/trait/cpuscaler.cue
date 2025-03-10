cpuscaler: {
	type: "trait"
	annotations: {}
	labels: {
		"ui-hidden": "true"
	}
	description: "Automatically scale the component based on CPU usage."
	attributes: {
		appliesToWorkloads: ["deployments.apps", "statefulsets.apps"]
	}
}

template: {
	outputs: cpuscaler: {
		apiVersion: "autoscaling/v1"
		kind:       "HorizontalPodAutoscaler"
		metadata: name: context.name
		spec: {
			scaleTargetRef: {
				apiVersion: parameter.targetAPIVersion
				kind:       parameter.targetKind
				name:       context.name
			}
			minReplicas:                    parameter.min
			maxReplicas:                    parameter.max
			targetCPUUtilizationPercentage: parameter.cpuUtil
		}
	}

	parameter: {
		// +usage=Specify the minimal number of replicas to which the autoscaler can scale down
		min: *1 | int
		// +usage=Specify the maximum number of of replicas to which the autoscaler can scale up
		max: *10 | int
		// +usage=Specify the average CPU utilization, for example, 50 means the CPU usage is 50%
		cpuUtil: *50 | int
		// +usage=Specify the apiVersion of scale target
		targetAPIVersion: *"apps/v1" | string
		// +usage=Specify the kind of scale target
		targetKind: *"Deployment" | string
	}
}

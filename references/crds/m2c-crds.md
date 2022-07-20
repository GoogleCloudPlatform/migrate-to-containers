# API Reference

## Packages
- [anthos-migrate.cloud.google.com/v1](#anthos-migratecloudgooglecomv1)
- [anthos-migrate.cloud.google.com/v1beta2](#anthos-migratecloudgooglecomv1beta2)


## anthos-migrate.cloud.google.com/v1

Package v1 contains API Schema definitions for the anthos-migrate.cloud.google.com v1 API group

### Resource Types
- [Migration](#migration)
- [MigrationList](#migrationlist)



#### Migration



Migration is the Schema for the migrations API

_Appears in:_
- [MigrationList](#migrationlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1`
| `kind` _string_ | `Migration`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[MigrationSpec](#migrationspec)_ |  |
| `status` _[MigrationStatus](#migrationstatus)_ |  |


#### MigrationCondition





_Appears in:_
- [MigrationStatus](#migrationstatus)

| Field | Description |
| --- | --- |
| `type` _MigrationConditionType_ |  |
| `status` _[ConditionStatus](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#conditionstatus-v1-core)_ |  |
| `reason` _string_ |  |
| `message` _string_ |  |
| `lastTransitionTime` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |


#### MigrationList



MigrationList contains a list of Migration



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1`
| `kind` _string_ | `MigrationList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[Migration](#migration) array_ |  |


#### MigrationSpec



MigrationSpec defines the desired state of a Migration. This object is immutable, once all the parameters are set.

_Appears in:_
- [Migration](#migration)

| Field | Description |
| --- | --- |
| `type` _string_ | Type describes the type of migration, available values are dependant on what AppX plugins are installed in the current cluster. |
| `sourceSnapshotTemplate` _[SourceSnapshotTemplate](#sourcesnapshottemplate)_ | Template to use when creating a source snapshot for this migration. |
| `artifactRepositoryRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ | Represents the repository to push the artifacts to during migration. |
| `imageRepositoryRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ | Image repository. |


#### MigrationStatus



MigrationStatus defines the observed state of Migration.

_Appears in:_
- [Migration](#migration)

| Field | Description |
| --- | --- |
| `conditions` _[MigrationCondition](#migrationcondition) array_ |  |
| `migrationPlanRef` _[TypedLocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#typedlocalobjectreference-v1-core)_ | References the object containing the migration plan. |
| `sourceSnapshotRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `discoveryTaskRef` _[TypedLocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#typedlocalobjectreference-v1-core)_ |  |


#### SourceSnapshotSpec





_Appears in:_
- [SourceSnapshotTemplate](#sourcesnapshottemplate)

| Field | Description |
| --- | --- |
| `sourceProviderRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `sourceId` _string_ | SourceID is used by the source provider to select a specific source from all those available to the source provider. The format is source provider dependent. |


#### SourceSnapshotTemplate





_Appears in:_
- [MigrationSpec](#migrationspec)

| Field | Description |
| --- | --- |
| `labels` _object (keys:string, values:string)_ | Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels |
| `annotations` _object (keys:string, values:string)_ | Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations |
| `spec` _[SourceSnapshotSpec](#sourcesnapshotspec)_ | Specification of the desired behavior of the pod. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status |



## anthos-migrate.cloud.google.com/v1beta2

Package v1beta2 contains API Schema definitions for the anthos-migrate.cloud.google.com v1beta2 API group

### Resource Types
- [AppXDiscoveryFlow](#appxdiscoveryflow)
- [AppXDiscoveryFlowList](#appxdiscoveryflowlist)
- [AppXDiscoveryResult](#appxdiscoveryresult)
- [AppXDiscoveryResultList](#appxdiscoveryresultlist)
- [AppXDiscoveryTask](#appxdiscoverytask)
- [AppXDiscoveryTaskList](#appxdiscoverytasklist)
- [AppXGenerateArtifactsFlow](#appxgenerateartifactsflow)
- [AppXGenerateArtifactsFlowList](#appxgenerateartifactsflowlist)
- [AppXGenerateArtifactsTask](#appxgenerateartifactstask)
- [AppXGenerateArtifactsTaskList](#appxgenerateartifactstasklist)
- [AppXPlugin](#appxplugin)
- [AppXPluginList](#appxpluginlist)
- [ArtifactsRepository](#artifactsrepository)
- [ArtifactsRepositoryList](#artifactsrepositorylist)
- [DiscoveryTask](#discoverytask)
- [DiscoveryTaskList](#discoverytasklist)
- [GenerateArtifactsFlow](#generateartifactsflow)
- [GenerateArtifactsFlowList](#generateartifactsflowlist)
- [GenerateArtifactsTask](#generateartifactstask)
- [GenerateArtifactsTaskList](#generateartifactstasklist)
- [ImageRepository](#imagerepository)
- [ImageRepositoryList](#imagerepositorylist)
- [LinuxDiscoveryReport](#linuxdiscoveryreport)
- [LinuxDiscoveryReportList](#linuxdiscoveryreportlist)
- [Migration](#migration)
- [MigrationList](#migrationlist)
- [MigrationSubSteps](#migrationsubsteps)
- [MigrationSubStepsList](#migrationsubstepslist)
- [ReplicatingVM](#replicatingvm)
- [ReplicatingVMList](#replicatingvmlist)
- [SourceProvider](#sourceprovider)
- [SourceProviderList](#sourceproviderlist)
- [SourceSnapshot](#sourcesnapshot)
- [SourceSnapshotList](#sourcesnapshotlist)
- [VmGenerateArtifactsFlow](#vmgenerateartifactsflow)
- [VmGenerateArtifactsFlowList](#vmgenerateartifactsflowlist)
- [VmGenerateArtifactsTask](#vmgenerateartifactstask)
- [VmGenerateArtifactsTaskList](#vmgenerateartifactstasklist)
- [VmGenerateArtifactsTaskProgress](#vmgenerateartifactstaskprogress)
- [VmGenerateArtifactsTaskProgressList](#vmgenerateartifactstaskprogresslist)
- [WindowsDiscovery](#windowsdiscovery)
- [WindowsDiscoveryList](#windowsdiscoverylist)
- [WindowsDiscoveryResult](#windowsdiscoveryresult)
- [WindowsDiscoveryResultList](#windowsdiscoveryresultlist)
- [WindowsGenerateArtifacts](#windowsgenerateartifacts)
- [WindowsGenerateArtifactsList](#windowsgenerateartifactslist)
- [WindowsGenerateArtifactsTask](#windowsgenerateartifactstask)
- [WindowsGenerateArtifactsTaskList](#windowsgenerateartifactstasklist)



#### AppXDataStatus





_Appears in:_
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `pod` _[PodStatus](#podstatus)_ |  |


#### AppXDiscoveryFlow



AppXDiscoveryFlow is the Schema for the appxdiscoveryflows API

_Appears in:_
- [AppXDiscoveryFlowList](#appxdiscoveryflowlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXDiscoveryFlow`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXDiscoveryFlowSpec](#appxdiscoveryflowspec)_ |  |
| `status` _[AppXDiscoveryFlowStatus](#appxdiscoveryflowstatus)_ |  |


#### AppXDiscoveryFlowList



AppXDiscoveryFlowList contains a list of AppXDiscoveryFlow



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXDiscoveryFlowList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[AppXDiscoveryFlow](#appxdiscoveryflow) array_ |  |


#### AppXDiscoveryFlowSpec



AppXDiscoveryFlowSpec defines the desired state of AppXDiscoveryFlow

_Appears in:_
- [AppXDiscoveryFlow](#appxdiscoveryflow)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `configs` _[Configs](#configs)_ |  |
| `warnings` _[Warning](#warning) array_ |  |


#### AppXDiscoveryFlowStatus



AppXDiscoveryFlowStatus defines the observed state of AppXDiscoveryFlow

_Appears in:_
- [AppXDiscoveryFlow](#appxdiscoveryflow)
- [SubResourceAppXStatus](#subresourceappxstatus)

| Field | Description |
| --- | --- |
| `task` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### AppXDiscoveryResult



AppXDiscoveryResult is the Schema for the appxdiscoveryresults API

_Appears in:_
- [AppXDiscoveryResultList](#appxdiscoveryresultlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXDiscoveryResult`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXDiscoveryResultSpec](#appxdiscoveryresultspec)_ |  |
| `status` _[AppXDiscoveryResultStatus](#appxdiscoveryresultstatus)_ |  |


#### AppXDiscoveryResultCondition





_Appears in:_
- [AppXDiscoveryResultStatus](#appxdiscoveryresultstatus)

| Field | Description |
| --- | --- |
| `type` _AppXDiscoveryResultConditionType_ |  |
| `status` _[ConditionStatus](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#conditionstatus-v1-core)_ |  |
| `reason` _string_ |  |
| `message` _string_ |  |
| `lastTransitionTime` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |


#### AppXDiscoveryResultList



AppXDiscoveryResultList contains a list of AppXDiscoveryResult



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXDiscoveryResultList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[AppXDiscoveryResult](#appxdiscoveryresult) array_ |  |


#### AppXDiscoveryResultSpec



AppXDiscoveryResultSpec defines the desired state of AppXDiscoveryResult

_Appears in:_
- [AppXDiscoveryResult](#appxdiscoveryresult)

| Field | Description |
| --- | --- |
| `task` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `appXGenerateArtifactsConfig` _string_ | Embedded YAML or CRD payload |
| `dataConfig` _[DataConfig](#dataconfig)_ |  |
| `warnings` _[Warning](#warning) array_ |  |


#### AppXDiscoveryResultStatus



AppXDiscoveryResultStatus defines the observed state of AppXDiscoveryResult

_Appears in:_
- [AppXDiscoveryResult](#appxdiscoveryresult)

| Field | Description |
| --- | --- |
| `conditions` _[AppXDiscoveryResultCondition](#appxdiscoveryresultcondition) array_ |  |


#### AppXDiscoveryTask



AppXDiscoveryTask is the Schema for the appxdiscoverytasks API

_Appears in:_
- [AppXDiscoveryTaskList](#appxdiscoverytasklist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXDiscoveryTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXDiscoveryTaskSpec](#appxdiscoverytaskspec)_ |  |
| `status` _[AppXDiscoveryTaskStatus](#appxdiscoverytaskstatus)_ |  |


#### AppXDiscoveryTaskList



AppXDiscoveryTaskList contains a list of AppXDiscoveryTask



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXDiscoveryTaskList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[AppXDiscoveryTask](#appxdiscoverytask) array_ |  |


#### AppXDiscoveryTaskSpec



AppXDiscoveryTaskSpec defines the desired state of AppXDiscoveryTask

_Appears in:_
- [AppXDiscoveryTask](#appxdiscoverytask)

| Field | Description |
| --- | --- |
| `flow` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### AppXDiscoveryTaskStatus



AppXDiscoveryTaskStatus defines the observed state of AppXDiscoveryTask

_Appears in:_
- [AppXDiscoveryTask](#appxdiscoverytask)

| Field | Description |
| --- | --- |
| `discoveryPod` _[PodStatus](#podstatus)_ |  |
| `discoveryItems` _[AppXRepositoryDelivery](#appxrepositorydelivery)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |


#### AppXExistingPvc





_Appears in:_
- [AppXVolume](#appxvolume)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `subPath` _[string](#string)_ |  |


#### AppXGenerateArtifactsFlow



AppXGenerateArtifactsFlow is the Schema for the appxgenerateartifactsflows API

_Appears in:_
- [AppXGenerateArtifactsFlowList](#appxgenerateartifactsflowlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXGenerateArtifactsFlow`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXGenerateArtifactsFlowSpec](#appxgenerateartifactsflowspec)_ |  |


#### AppXGenerateArtifactsFlowList



AppXGenerateArtifactsFlowList contains a list of AppXGenerateArtifactsFlow



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXGenerateArtifactsFlowList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[AppXGenerateArtifactsFlow](#appxgenerateartifactsflow) array_ |  |


#### AppXGenerateArtifactsFlowSpec



AppXGenerateArtifactsFlowSpec defines the desired state of AppXGenerateArtifactsFlow

_Appears in:_
- [AppXGenerateArtifactsFlow](#appxgenerateartifactsflow)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `appXGenerateArtifactsConfig` _string_ | Application specific configuration. |
| `dataConfig` _[DataConfig](#dataconfig)_ |  |
| `warnings` _[Warning](#warning) array_ |  |
| `dismissDiscoveryWarnings` _boolean_ |  |


#### AppXGenerateArtifactsFlowStatus



AppXGenerateArtifactsFlowStatus defines the observed state of AppXGenerateArtifactsFlow

_Appears in:_
- [SubResourceAppXStatus](#subresourceappxstatus)

| Field | Description |
| --- | --- |
| `task` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### AppXGenerateArtifactsTask



AppXGenerateArtifactsTask is the Schema for the appxgenerateartifactstasks API

_Appears in:_
- [AppXGenerateArtifactsTaskList](#appxgenerateartifactstasklist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXGenerateArtifactsTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXGenerateArtifactsTaskSpec](#appxgenerateartifactstaskspec)_ |  |
| `status` _[AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)_ |  |


#### AppXGenerateArtifactsTaskList



AppXGenerateArtifactsTaskList contains a list of AppXGenerateArtifactsTask



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXGenerateArtifactsTaskList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[AppXGenerateArtifactsTask](#appxgenerateartifactstask) array_ |  |


#### AppXGenerateArtifactsTaskSpec



AppXGenerateArtifactsTaskSpec defines the desired state of AppXGenerateArtifactsTask

_Appears in:_
- [AppXGenerateArtifactsTask](#appxgenerateartifactstask)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `flow` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### AppXGenerateArtifactsTaskStatus



AppXGenerateArtifactsTaskStatus defines the observed state of AppXGenerateArtifactsTask

_Appears in:_
- [AppXGenerateArtifactsTask](#appxgenerateartifactstask)

| Field | Description |
| --- | --- |
| `extractPod` _[PodStatus](#podstatus)_ |  |
| `dataExtract` _[AppXDataStatus](#appxdatastatus)_ |  |
| `artifacts` _[AppXRepositoryDelivery](#appxrepositorydelivery)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `operation` _[OperationInfo](#operationinfo)_ | Note: both Operation and Status hold OperationStatus. Operation.Status is used for maintaining error state. Status is used for internal state management. |


#### AppXNewPVC





_Appears in:_
- [AppXVolume](#appxvolume)

| Field | Description |
| --- | --- |
| `spec` _[PersistentVolumeClaimSpec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolumeclaimspec-v1-core)_ |  |


#### AppXPlugin



AppXPlugin is the Schema for the appxplugins API

_Appears in:_
- [AppXPluginList](#appxpluginlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXPlugin`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXPluginSpec](#appxpluginspec)_ |  |
| `status` _[AppXPluginStatus](#appxpluginstatus)_ |  |


#### AppXPluginList



AppXPluginList contains a list of AppXPlugin



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXPluginList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[AppXPlugin](#appxplugin) array_ |  |


#### AppXPluginSpec



AppXPluginSpec defines the desired state of AppXPlugin

_Appears in:_
- [AppXPlugin](#appxplugin)

| Field | Description |
| --- | --- |
| `discoverImage` _string_ | INSERT ADDITIONAL SPEC FIELDS - desired state of cluster Important: Run "make" to regenerate code after modifying this file |
| `discoverCommand` _string array_ |  |
| `generateArtifactsImage` _string_ |  |
| `generateArtifactsCommand` _string array_ |  |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ |  |
| `validationSchema` _string_ |  |
| `osType` _[OsType](#ostype)_ |  |
| `configs` _[Configs](#configs)_ |  |
| `parameterDefs` _[ParameterDef](#parameterdef) array_ |  |
| `defaultArguments` _[Parameter](#parameter) array_ |  |




#### AppXRepositoryDelivery



AppXRepositoryDelivery is not a standalone CRD, but rather a field contained in discovery and extract task statuses to describe their produced items for posterity

_Appears in:_
- [AppXDiscoveryTaskStatus](#appxdiscoverytaskstatus)
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `type` _string_ |  |
| `bucket` _string_ |  |
| `region` _string_ | Region is only set when type is s3 |
| `folder` _string_ |  |


#### AppXVolume





_Appears in:_
- [DataConfig](#dataconfig)

| Field | Description |
| --- | --- |
| `existingPvc` _[AppXExistingPvc](#appxexistingpvc)_ |  |
| `newPvc` _[AppXNewPVC](#appxnewpvc)_ |  |
| `folders` _string array_ |  |
| `deploymentPvcName` _string_ | The name of the PVC that deployed pods in the target cluster (specified in the deployment spec yaml) will use to access the data in this volume |


#### ApplicationArtifactsStatus





_Appears in:_
- [Artifacts](#artifacts)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `description` _string_ |  |
| `image` _string_ |  |
| `imageBase` _string_ |  |
| `deploymentYaml` _string_ |  |
| `dockerfile` _string_ |  |
| `windowsArtifactsFile` _string_ |  |


#### Applications





_Appears in:_
- [MigrationPlan](#migrationplan)

| Field | Description |
| --- | --- |
| `iis` _ConfigFile_ |  |
| `image` _ImageInfo_ |  |
| `useractions` _[UserActions](#useractions)_ |  |


#### Artifacts





_Appears in:_
- [MigrationStatus](#migrationstatus)

| Field | Description |
| --- | --- |
| `image` _string_ | TODO: Deprecated, remove when we update CRD version |
| `imageBase` _string_ |  |
| `deploymentFiles` _[DeploymentFiles](#deploymentfiles)_ |  |
| `type` _string_ |  |
| `bucket` _string_ |  |
| `region` _string_ | Region is only set when type is s3 |
| `artifactsManifestFile` _string_ | Path to file |
| `migrationFile` _string_ | Path to file |
| `applications` _[ApplicationArtifactsStatus](#applicationartifactsstatus) array_ |  |


#### ArtifactsRepository



ArtifactsRepository is the Schema for the artifactsrepositories API

_Appears in:_
- [ArtifactsRepositoryList](#artifactsrepositorylist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `ArtifactsRepository`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ArtifactsRepositorySpec](#artifactsrepositoryspec)_ |  |
| `status` _[ArtifactsRepositoryStatus](#artifactsrepositorystatus)_ |  |


#### ArtifactsRepositoryCondition



ArtifactsRepositoryCondition is derieved from the v1.Condition type of kubernetes. ObservedGeneration was removed as we consider it part of the Status. The types of Type and Reason have been changed to match specific enums.

_Appears in:_
- [ArtifactsRepositoryStatus](#artifactsrepositorystatus)

| Field | Description |
| --- | --- |
| `type` _ArtifactsRepositoryConditionType_ | type of condition in CamelCase or in foo.example.com/CamelCase. --- Many .condition.type values are consistent across resources like Available, but because arbitrary conditions can be useful (see .node.status.conditions), the ability to deconflict is important. The regex it matches is (dns1123SubdomainFmt/)?(qualifiedNameFmt) |
| `status` _[ConditionStatus](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#conditionstatus-v1-meta)_ | status of the condition, one of True, False, Unknown. |
| `lastTransitionTime` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ | lastTransitionTime is the last time the condition transitioned from one status to another. This should be when the underlying condition changed.  If that is not known, then using the time when the API field changed is acceptable. |
| `reason` _ArtifactsRepositoryConditionReason_ | reason contains a programmatic identifier indicating the reason for the condition's last transition. Producers of specific condition types may define expected values and meanings for this field, and whether the values are considered a guaranteed API. The value should be a CamelCase string. This field may not be empty. |
| `message` _string_ | message is a human readable message indicating details about the transition. This may be an empty string. |


#### ArtifactsRepositoryCredentials



deprecated

_Appears in:_
- [ArtifactsRepositorySpec](#artifactsrepositoryspec)

| Field | Description |
| --- | --- |
| `type` _string_ |  |
| `secret` _string_ |  |


#### ArtifactsRepositoryList



ArtifactsRepositoryList contains a list of ArtifactsRepository



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `ArtifactsRepositoryList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ArtifactsRepository](#artifactsrepository) array_ |  |


#### ArtifactsRepositoryRef





_Appears in:_
- [Deployment](#deployment)
- [MigrationSpec](#migrationspec)
- [WindowsGenerateArtifactsSpec](#windowsgenerateartifactsspec)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `spec` _[ArtifactsRepositorySpec](#artifactsrepositoryspec)_ |  |


#### ArtifactsRepositorySpec



ArtifactsRepositorySpec defines the desired state of ArtifactsRepository

_Appears in:_
- [ArtifactsRepository](#artifactsrepository)
- [ArtifactsRepositoryRef](#artifactsrepositoryref)

| Field | Description |
| --- | --- |
| `credentials` _[ArtifactsRepositoryCredentials](#artifactsrepositorycredentials)_ | deprecated |
| `bucket` _string_ | deprecated |
| `gcs` _[GcsRespositorySpec](#gcsrespositoryspec)_ |  |
| `s3` _[S3RespositorySpec](#s3respositoryspec)_ |  |


#### ArtifactsRepositoryStatus



ArtifactsRepositoryStatus defines the observed state of ArtifactsRepository

_Appears in:_
- [ArtifactsRepository](#artifactsrepository)

| Field | Description |
| --- | --- |
| `observedGeneration` _integer_ | Contains the spec generation the reconciler saw the last time it woke up. |
| `conditions` _[ArtifactsRepositoryCondition](#artifactsrepositorycondition) array_ | A list of current statuses of the repository. |


#### AwsCredentialsSpec





_Appears in:_
- [LocalAwsSourceSpec](#localawssourcespec)

| Field | Description |
| --- | --- |
| `secretRef` _[SecretReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#secretreference-v1-core)_ |  |


#### BasicState

_Underlying type:_ `string`



_Appears in:_
- [MigrateForCEHealthStatus](#migrateforcehealthstatus)



#### BigFileInfo





_Appears in:_
- [LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)

| Field | Description |
| --- | --- |
| `path` _string_ |  |
| `size` _string_ | Human readable size |
| `lastModified` _string_ |  |
| `lastAccess` _string_ |  |


#### ComputeEngineSourceSnapshot





_Appears in:_
- [SourceSnapshotSpec](#sourcesnapshotspec)

| Field | Description |
| --- | --- |
| `diskSnapshots` _string array_ |  |
| `sourceDisks` _[Volume](#volume) array_ |  |
| `copiedDisks` _[Volume](#volume) array_ |  |
| `pvcs` _string array_ |  |


#### ComputeEngineSourceSnapshotStatus





_Appears in:_
- [SourceSnapshotStatus](#sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `volumes` _object (keys:string, values:[GceVolumeStatus](#gcevolumestatus))_ |  |
| `sourceDisks` _[Volume](#volume) array_ |  |
| `v2kCsiPvc` _[PvcStatus](#pvcstatus)_ |  |
| `bootVolumeName` _string_ |  |
| `destinationZone` _string_ |  |
| `destinationProject` _string_ |  |


#### Configs





_Appears in:_
- [AppXDiscoveryFlowSpec](#appxdiscoveryflowspec)
- [AppXPluginSpec](#appxpluginspec)
- [GenerateArtifactsFlowSpec](#generateartifactsflowspec)
- [MigrationSpec](#migrationspec)
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `jobsConfig` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### CopyProgress





_Appears in:_
- [DataStatus](#datastatus)
- [ImageExtractionStatus](#imageextractionstatus)

| Field | Description |
| --- | --- |
| `sourceSizeBytes` _integer_ |  |
| `copiedBytes` _integer_ |  |


#### DataConfig





_Appears in:_
- [AppXDiscoveryResultSpec](#appxdiscoveryresultspec)
- [AppXGenerateArtifactsFlowSpec](#appxgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `volumes` _[AppXVolume](#appxvolume) array_ |  |


#### DataStatus





_Appears in:_
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `PodStatus` _[PodStatus](#podstatus)_ |  |
| `copyProgressByPvc` _object (keys:string, values:[CopyProgress](#copyprogress))_ |  |


#### DataVolume





_Appears in:_
- [GenerateArtifactsFlowSpec](#generateartifactsflowspec)
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `pvc` _[Pvc](#pvc)_ |  |
| `folders` _string array_ |  |


#### Deployment





_Appears in:_
- [LinuxMigrationCommonSpec](#linuxmigrationcommonspec)
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `artifactsRepository` _[ArtifactsRepositoryRef](#artifactsrepositoryref)_ |  |
| `folder` _string_ |  |
| `appName` _string_ |  |
| `endpoints` _[Endpoint](#endpoint) array_ |  |
| `nfsMounts` _[DeploymentNfsMount](#deploymentnfsmount) array_ |  |
| `logPaths` _[LogInfo](#loginfo) array_ |  |
| `probes` _[Probes](#probes)_ |  |


#### DeploymentFiles





_Appears in:_
- [Artifacts](#artifacts)

| Field | Description |
| --- | --- |
| `type` _string_ |  |
| `bucket` _string_ |  |
| `region` _string_ | Region is only set when type is s3 |
| `artifactsManifestFile` _string_ | Path to file |
| `migrationFile` _string_ | Path to file |
| `deploymentYaml` _string_ | Path to file |
| `dockerfile` _string_ | Path to file |
| `windowsArtifactsFile` _string_ | Path to file |


#### DeploymentNfsMount





_Appears in:_
- [Deployment](#deployment)

| Field | Description |
| --- | --- |
| `mountPoint` _string_ |  |
| `exportedDirectory` _string_ |  |
| `nfsServer` _string_ |  |
| `mountOptions` _string array_ |  |
| `enabled` _boolean_ |  |


#### DeploymentStatus





_Appears in:_
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `repositoryLocation` _[RepositoryLocation](#repositorylocation)_ |  |
| `repositoryBucket` _string_ | deprecated |
| `artifactsManifestFile` _string_ |  |
| `migrationFile` _string_ |  |
| `deploymentYaml` _string_ |  |
| `dockerfile` _string_ |  |


#### DiscoveredSystemService





_Appears in:_
- [LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)

| Field | Description |
| --- | --- |
| `SystemService` _[SystemService](#systemservice)_ |  |
| `requiresV1runtime` _boolean_ |  |


#### DiscoveryTask



DiscoveryTask is the Schema for the discoverytasks API

_Appears in:_
- [DiscoveryTaskList](#discoverytasklist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `DiscoveryTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[DiscoveryTaskSpec](#discoverytaskspec)_ |  |
| `status` _[DiscoveryTaskStatus](#discoverytaskstatus)_ |  |




#### DiscoveryTaskList



DiscoveryTaskList contains a list of DiscoveryTask



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `DiscoveryTaskList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[DiscoveryTask](#discoverytask) array_ |  |


#### DiscoveryTaskSpec



DiscoveryTaskSpec defines the desired state of DiscoveryTask

_Appears in:_
- [DiscoveryTask](#discoverytask)

| Field | Description |
| --- | --- |
| `type` _DiscoveryType_ |  |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### DiscoveryTaskStatus



DiscoveryTaskStatus defines the observed state of DiscoveryTask

_Appears in:_
- [DiscoveryTask](#discoverytask)
- [SubResourceDiscoveryTaskStatus](#subresourcediscoverytaskstatus)

| Field | Description |
| --- | --- |
| `discover` _[PodStatus](#podstatus)_ |  |
| `discoveryReport` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `operation` _[OperationInfo](#operationinfo)_ |  |
| `error` _string_ |  |


#### DiskConfig





_Appears in:_
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `diskFormat` _DiskFormat_ | Format to use for the target disk - one of: "raw", "qcow2". Default's to the cluster's default vm image format if DiskConfig is nil in flow object. |
| `enableCompression` _boolean_ | Allows enabling disk compression if disk format is "qcow2". |


#### Ec2SnapshotInfo





_Appears in:_
- [Ec2VolumeStatus](#ec2volumestatus)



#### Ec2VolumeInfo





_Appears in:_
- [Ec2VolumeStatus](#ec2volumestatus)



#### Ec2VolumeStatus





_Appears in:_
- [LocalEc2SourceSnapshotStatus](#localec2sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `pvc` _[PvcStatus](#pvcstatus)_ |  |
| `copiedDisk` _[Ec2VolumeInfo](#ec2volumeinfo)_ |  |
| `snapshot` _[Ec2SnapshotInfo](#ec2snapshotinfo)_ |  |


#### Endpoint





_Appears in:_
- [Deployment](#deployment)

| Field | Description |
| --- | --- |
| `port` _integer_ |  |
| `protocol` _[Protocol](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#protocol-v1-core)_ |  |
| `name` _string_ |  |


#### ErrorStatus



ErrorStatus holds error handling state to be persisted on a k8s resource.

_Appears in:_
- [OperationInfo](#operationinfo)

| Field | Description |
| --- | --- |
| `numErrors` _integer_ |  |
| `lastError` _string_ |  |
| `lastErrorCatalogCode` _CatalogCode_ |  |
| `lastErrorTime` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |


#### ExportProgressDiskStatus

_Underlying type:_ `string`

ExportProgressDiskStatus is used to indicate the download status of a disk being exported.

_Appears in:_
- [VmGenerateArtifactsTaskExportProgress](#vmgenerateartifactstaskexportprogress)





#### GceCredentialsSpec





_Appears in:_
- [LocalGceSourceSpec](#localgcesourcespec)
- [LocalOVFSourceSpec](#localovfsourcespec)
- [MigrateForCEService](#migrateforceservice)

| Field | Description |
| --- | --- |
| `secretRef` _[SecretReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#secretreference-v1-core)_ |  |


#### GceResourceStatus





_Appears in:_
- [GceVolumeStatus](#gcevolumestatus)



#### GceVolumeStatus





_Appears in:_
- [ComputeEngineSourceSnapshotStatus](#computeenginesourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `pvc` _[PvcStatus](#pvcstatus)_ |  |
| `copiedDisk` _[GceResourceStatus](#gceresourcestatus)_ |  |
| `snapshot` _[GceResourceStatus](#gceresourcestatus)_ |  |


#### GcsCredentialsSpec





_Appears in:_
- [GcsRespositorySpec](#gcsrespositoryspec)

| Field | Description |
| --- | --- |
| `secretRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### GcsRepositoryLocation





_Appears in:_
- [RepositoryLocation](#repositorylocation)

| Field | Description |
| --- | --- |
| `bucket` _string_ |  |


#### GcsRespositorySpec





_Appears in:_
- [ArtifactsRepositorySpec](#artifactsrepositoryspec)

| Field | Description |
| --- | --- |
| `serviceAccount` _[GcsCredentialsSpec](#gcscredentialsspec)_ | GCS credentials reference. |
| `bucket` _string_ | GCS bucket, will be created on demand. |


#### GenerateArtifactsFlow



GenerateArtifactsFlow is the Schema for the generateartifactsflows API

_Appears in:_
- [GenerateArtifactsFlowList](#generateartifactsflowlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `GenerateArtifactsFlow`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[GenerateArtifactsFlowSpec](#generateartifactsflowspec)_ |  |
| `status` _[GenerateArtifactsFlowStatus](#generateartifactsflowstatus)_ |  |


#### GenerateArtifactsFlowList



GenerateArtifactsFlowList contains a list of GenerateArtifactsFlow



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `GenerateArtifactsFlowList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[GenerateArtifactsFlow](#generateartifactsflow) array_ |  |


#### GenerateArtifactsFlowSpec



GenerateArtifactsFlowSpec defines the desired state of GenerateArtifactsFlow

_Appears in:_
- [GenerateArtifactsFlow](#generateartifactsflow)

| Field | Description |
| --- | --- |
| `intent` _[Intent](#intent)_ |  |
| `LinuxMigrationCommonSpec` _[LinuxMigrationCommonSpec](#linuxmigrationcommonspec)_ |  |
| `dataVolumes` _[DataVolume](#datavolume) array_ |  |
| `configs` _[Configs](#configs)_ |  |


#### GenerateArtifactsFlowStatus



GenerateArtifactsFlowStatus defines the observed state of GenerateArtifactsFlow

_Appears in:_
- [GenerateArtifactsFlow](#generateartifactsflow)

| Field | Description |
| --- | --- |
| `volumesSpecs` _object (keys:string, values:[VolumeSpec](#volumespec))_ |  |


#### GenerateArtifactsTask



GenerateArtifactsTask is the Schema for the generateartifactstasks API

_Appears in:_
- [GenerateArtifactsTaskList](#generateartifactstasklist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `GenerateArtifactsTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[GenerateArtifactsTaskSpec](#generateartifactstaskspec)_ |  |
| `status` _[GenerateArtifactsTaskStatus](#generateartifactstaskstatus)_ |  |


#### GenerateArtifactsTaskList



GenerateArtifactsTaskList contains a list of GenerateArtifactsTask



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `GenerateArtifactsTaskList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[GenerateArtifactsTask](#generateartifactstask) array_ |  |


#### GenerateArtifactsTaskSpec



GenerateArtifactsTaskSpec defines the desired state of GenerateArtifactsTask

_Appears in:_
- [GenerateArtifactsTask](#generateartifactstask)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### GenerateArtifactsTaskStatus



GenerateArtifactsTaskStatus defines the observed state of GenerateArtifactsTask

_Appears in:_
- [GenerateArtifactsTask](#generateartifactstask)
- [SubResourceGenerateArtifactsTaskStatus](#subresourcegenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `image` _[ImageStatus](#imagestatus)_ |  |
| `data` _[DataStatus](#datastatus)_ |  |
| `deployment` _[DeploymentStatus](#deploymentstatus)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `operation` _[OperationInfo](#operationinfo)_ | Note: both Operation and Status hold OperationStatus. Operation.Status is used for maintaining error state. Status is used for internal state management. |
| `deletedOldSnapshot` _boolean_ |  |


#### Global





_Appears in:_
- [LinuxMigrationCommonSpec](#linuxmigrationcommonspec)

| Field | Description |
| --- | --- |
| `filters` _string array_ |  |


#### HTTPConfigSpec





_Appears in:_
- [LocalOVFSourceSpec](#localovfsourcespec)

| Field | Description |
| --- | --- |
| `ignoreCert` _boolean_ |  |


#### Image





_Appears in:_
- [LinuxMigrationCommonSpec](#linuxmigrationcommonspec)

| Field | Description |
| --- | --- |
| `imageRepository` _[ImageRepositoryRef](#imagerepositoryref)_ |  |
| `name` _string_ |  |
| `base` _string_ |  |
| `systemServices` _[SystemService](#systemservice) array_ |  |


#### ImageExtractionStatus





_Appears in:_
- [ImageStatus](#imagestatus)

| Field | Description |
| --- | --- |
| `PodStatus` _[PodStatus](#podstatus)_ |  |
| `copyProgress` _[CopyProgress](#copyprogress)_ |  |


#### ImageRepository



ImageRepository is the Schema for the imagerepositories API

_Appears in:_
- [ImageRepositoryList](#imagerepositorylist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `ImageRepository`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ImageRepositorySpec](#imagerepositoryspec)_ |  |
| `status` _[ImageRepositoryStatus](#imagerepositorystatus)_ |  |


#### ImageRepositoryCredentials





_Appears in:_
- [ImageRepositorySpec](#imagerepositoryspec)

| Field | Description |
| --- | --- |
| `type` _[ImageRepositoryCredentialsType](#imagerepositorycredentialstype)_ |  |
| `secret` _string_ |  |


#### ImageRepositoryCredentialsType

_Underlying type:_ `string`



_Appears in:_
- [ImageRepositoryCredentials](#imagerepositorycredentials)



#### ImageRepositoryList



ImageRepositoryList contains a list of ImageRepository



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `ImageRepositoryList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ImageRepository](#imagerepository) array_ |  |


#### ImageRepositoryRef





_Appears in:_
- [Image](#image)
- [MigrationSpec](#migrationspec)
- [VMImage](#vmimage)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `spec` _[ImageRepositorySpec](#imagerepositoryspec)_ |  |


#### ImageRepositorySSLConfig





_Appears in:_
- [ImageRepositorySpec](#imagerepositoryspec)

| Field | Description |
| --- | --- |
| `caPEM` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### ImageRepositorySpec



ImageRepositorySpec defines the desired state of ImageRepository

_Appears in:_
- [ImageRepository](#imagerepository)
- [ImageRepositoryRef](#imagerepositoryref)

| Field | Description |
| --- | --- |
| `url` _string_ |  |
| `ssl` _[ImageRepositorySSLConfig](#imagerepositorysslconfig)_ |  |
| `credentials` _[ImageRepositoryCredentials](#imagerepositorycredentials)_ |  |




#### ImageStatus





_Appears in:_
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `extraction` _[ImageExtractionStatus](#imageextractionstatus)_ |  |
| `upload` _[ImageUploadStatus](#imageuploadstatus)_ |  |


#### ImageUploadStatus





_Appears in:_
- [ImageStatus](#imagestatus)

| Field | Description |
| --- | --- |
| `PodStatus` _[PodStatus](#podstatus)_ |  |
| `image` _string_ |  |
| `imageBase` _string_ |  |


#### Intent

_Underlying type:_ `string`



_Appears in:_
- [GenerateArtifactsFlowSpec](#generateartifactsflowspec)
- [MigrationStatus](#migrationstatus)
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)



#### LdtDetails





_Appears in:_
- [LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)

| Field | Description |
| --- | --- |
| `filename` _string_ |  |
| `version` _string_ |  |
| `collectionTime` _string_ |  |


#### LinuxDiscoveryReport



LinuxDiscoveryReport is the Schema for the linuxdiscoveryreports API

_Appears in:_
- [LinuxDiscoveryReportList](#linuxdiscoveryreportlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `LinuxDiscoveryReport`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)_ |  |
| `status` _[LinuxDiscoveryReportStatus](#linuxdiscoveryreportstatus)_ |  |


#### LinuxDiscoveryReportList



LinuxDiscoveryReportList contains a list of LinuxDiscoveryReport



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `LinuxDiscoveryReportList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[LinuxDiscoveryReport](#linuxdiscoveryreport) array_ |  |


#### LinuxDiscoveryReportSpec



LinuxDiscoveryReportSpec defines the desired state of LinuxDiscoveryReport

_Appears in:_
- [LinuxDiscoveryReport](#linuxdiscoveryreport)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `systemServices` _[DiscoveredSystemService](#discoveredsystemservice) array_ |  |
| `openPorts` _[OpenPort](#openport) array_ |  |
| `nfsMounts` _[NfsMount](#nfsmount) array_ |  |
| `logPaths` _[LogInfo](#loginfo) array_ |  |
| `ldtDetails` _[LdtDetails](#ldtdetails)_ |  |
| `bigFiles` _[BigFileInfo](#bigfileinfo) array_ |  |
| `sparseFiles` _[BigFileInfo](#bigfileinfo) array_ |  |




#### LinuxMigrationCommonSpec



LinuxMigrationCommonSpec is meant to hold the fields common to the built-in linux migration, and the AppX-based Linux migration implementation during the transition, until we can fully remove the built-in implementation.

_Appears in:_
- [GenerateArtifactsFlowSpec](#generateartifactsflowspec)

| Field | Description |
| --- | --- |
| `v2kServiceManager` _boolean_ |  |
| `image` _[Image](#image)_ |  |
| `global` _[Global](#global)_ |  |
| `deployment` _[Deployment](#deployment)_ |  |


#### LocalAwsSourceSpec





_Appears in:_
- [LocalSourceSpec](#localsourcespec)

| Field | Description |
| --- | --- |
| `region` _string_ |  |
| `secretAccessKey` _[AwsCredentialsSpec](#awscredentialsspec)_ |  |


#### LocalEc2SourceSnapshotStatus





_Appears in:_
- [SourceSnapshotStatus](#sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `volumes` _object (keys:string, values:[Ec2VolumeStatus](#ec2volumestatus))_ |  |
| `v2kCsiPvc` _[PvcStatus](#pvcstatus)_ |  |
| `bootVolumeName` _string_ |  |
| `destinationZone` _string_ |  |


#### LocalGceSourceSpec





_Appears in:_
- [LocalSourceSpec](#localsourcespec)

| Field | Description |
| --- | --- |
| `project` _string_ |  |
| `serviceAccount` _[GceCredentialsSpec](#gcecredentialsspec)_ |  |


#### LocalOVFSourceSnapshotStatus





_Appears in:_
- [SourceSnapshotStatus](#sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `hardwareSpec` _[VmwareHardwareSpec](#vmwarehardwarespec)_ |  |


#### LocalOVFSourceSpec





_Appears in:_
- [LocalSourceSpec](#localsourcespec)

| Field | Description |
| --- | --- |
| `baseURL` _string_ |  |
| `httpConfigSpec` _[HTTPConfigSpec](#httpconfigspec)_ |  |
| `gcsConfigSpec` _[GceCredentialsSpec](#gcecredentialsspec)_ |  |


#### LocalSourceSpec





_Appears in:_
- [SourceProviderSpec](#sourceproviderspec)

| Field | Description |
| --- | --- |
| `localVmware` _[LocalVmwareSourceSpec](#localvmwaresourcespec)_ |  |
| `gce` _[LocalGceSourceSpec](#localgcesourcespec)_ |  |
| `localAws` _[LocalAwsSourceSpec](#localawssourcespec)_ |  |
| `localOVF` _[LocalOVFSourceSpec](#localovfsourcespec)_ |  |


#### LocalVmwareSourceSnapshotStatus





_Appears in:_
- [SourceSnapshotStatus](#sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `createSnapshot` _[VmwareTracker](#vmwaretracker)_ |  |
| `cloneVm` _[VmwareTracker](#vmwaretracker)_ |  |
| `createPvcs` _[PvcStatus](#pvcstatus) array_ |  |
| `hardwareSpec` _[VmwareHardwareSpec](#vmwarehardwarespec)_ |  |
| `accessType` _string_ |  |


#### LocalVmwareSourceSpec





_Appears in:_
- [LocalSourceSpec](#localsourcespec)

| Field | Description |
| --- | --- |
| `verifyCertificate` _boolean_ | Whether VMware API will fail on environments with invalid certificates. defaults to false. Corresponds to the not value of vSphere insecure flag. |
| `useHttp` _boolean_ | Use a HTTP connection to vSphere |
| `accessType` _string_ | Deprecated. AccessType is now determined internally, and this value will be ignored. |
| `address` _string_ |  |
| `username` _string_ |  |
| `password` _[PasswordRef](#passwordref)_ |  |
| `dc` _string_ |  |


#### LogInfo





_Appears in:_
- [Deployment](#deployment)
- [LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)

| Field | Description |
| --- | --- |
| `appName` _string_ |  |
| `globs` _string array_ |  |


#### MigrateForCECloudDetails





_Appears in:_
- [MigrateForCEManagementDetails](#migrateforcemanagementdetails)

| Field | Description |
| --- | --- |
| `platform` _string_ |  |
| `name` _string_ |  |




#### MigrateForCEManagementDetails





_Appears in:_
- [MigrateForCESourceSpec](#migrateforcesourcespec)

| Field | Description |
| --- | --- |
| `address` _string_ |  |
| `password` _[PasswordRef](#passwordref)_ |  |
| `cloudDetails` _[MigrateForCECloudDetails](#migrateforceclouddetails)_ |  |
| `cloudExtension` _string_ |  |


#### MigrateForCEService





_Appears in:_
- [RemoteSourceSpec](#remotesourcespec)
- [ReplicatingVMSpec](#replicatingvmspec)

| Field | Description |
| --- | --- |
| `sourceName` _string_ |  |
| `location` _string_ |  |
| `project` _string_ |  |
| `serviceAccount` _[GceCredentialsSpec](#gcecredentialsspec)_ |  |
| `replicatingVMDefaults` _[ReplicatingVMDefaults](#replicatingvmdefaults)_ |  |


#### MigrateForCESourceSpec





_Appears in:_
- [SourceProviderSpec](#sourceproviderspec)

| Field | Description |
| --- | --- |
| `management` _[MigrateForCEManagementDetails](#migrateforcemanagementdetails)_ |  |


#### MigrateForCe





_Appears in:_
- [SourceSnapshotSpec](#sourcesnapshotspec)

| Field | Description |
| --- | --- |
| `runMode` _string_ |  |


#### MigrateForCeStatus





_Appears in:_
- [SourceSnapshotStatus](#sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `pvc` _[PvcStatus](#pvcstatus)_ |  |


#### Migration



Migration is the Schema for the migrations API

_Appears in:_
- [MigrationList](#migrationlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `Migration`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[MigrationSpec](#migrationspec)_ |  |
| `status` _[MigrationStatus](#migrationstatus)_ |  |




#### MigrationList



MigrationList contains a list of Migration



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `MigrationList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[Migration](#migration) array_ |  |


#### MigrationPlan





_Appears in:_
- [WindowsGenerateArtifactsSpec](#windowsgenerateartifactsspec)

| Field | Description |
| --- | --- |
| `target` _[TargetSystem](#targetsystem)_ |  |
| `applications` _[Applications](#applications)_ |  |


#### MigrationSpec



MigrationSpec defines the desired state of Migration

_Appears in:_
- [Migration](#migration)

| Field | Description |
| --- | --- |
| `osType` _[OsType](#ostype)_ |  |
| `formFactor` _FormFactor_ |  |
| `appType` _AppType_ |  |
| `sourceSnapshot` _[SourceSnapshotSpec](#sourcesnapshotspec)_ |  |
| `parameters` _[Parameter](#parameter) array_ | Optional configuration for this migration |
| `artifactsRepository` _[ArtifactsRepositoryRef](#artifactsrepositoryref)_ | This should be generalized throughout all the flows, artifacts repository should be defined once per migration. This field is initially added for Delta |
| `imageRepository` _[ImageRepositoryRef](#imagerepositoryref)_ | The image repository to which images should be uploaded, in case the extraction phase image needs to upload images. |
| `configs` _[Configs](#configs)_ | Debug configurations for the aggregator |


#### MigrationStatus



MigrationStatus defines the observed state of Migration

_Appears in:_
- [Migration](#migration)

| Field | Description |
| --- | --- |
| `flowId` _string_ |  |
| `currentOperation` _Operation_ |  |
| `status` _[OperationStatus](#operationstatus)_ | Status of the migration process |
| `error` _string_ |  |
| `MigrationSubStepsStatus` _[MigrationSubStepsStatus](#migrationsubstepsstatus)_ |  |
| `reconcileOperationInfo` _[OperationInfo](#operationinfo)_ | Reconciliation loop status, e.g. if some API error is thrown while trying to reconcile |
| `resources` _[MigrationSubResources](#migrationsubresources)_ |  |
| `artifacts` _[Artifacts](#artifacts)_ |  |
| `intent` _[Intent](#intent)_ |  |


#### MigrationSubResources





_Appears in:_
- [MigrationStatus](#migrationstatus)

| Field | Description |
| --- | --- |
| `sourceSnapshot` _[SubResourceSourceSnapshotStatus](#subresourcesourcesnapshotstatus)_ |  |
| `generateArtifacts` _[SubResourceGenerateArtifactsStatus](#subresourcegenerateartifactsstatus)_ |  |
| `windowsDiscovery` _[SubResourceWindowsDiscoveryStatus](#subresourcewindowsdiscoverystatus)_ |  |
| `windowsGenerateArtifacts` _[SubResourceWindowsGenerateArtifactsStatus](#subresourcewindowsgenerateartifactsstatus)_ |  |
| `discovery` _[SubResourceDiscoveryStatus](#subresourcediscoverystatus)_ |  |
| `vmGenerateArtifacts` _[SubResourceVmGenerateArtifactsStatus](#subresourcevmgenerateartifactsstatus)_ |  |
| `appX` _[SubResourceAppXStatus](#subresourceappxstatus)_ |  |


#### MigrationSubSteps



MigrationSubSteps is the Schema for the migrationsubsteps API

_Appears in:_
- [MigrationSubStepsList](#migrationsubstepslist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `MigrationSubSteps`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[MigrationSubStepsSpec](#migrationsubstepsspec)_ |  |
| `status` _[MigrationSubStepsStatus](#migrationsubstepsstatus)_ |  |


#### MigrationSubStepsList



MigrationSubStepsList contains a list of MigrationSubSteps



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `MigrationSubStepsList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[MigrationSubSteps](#migrationsubsteps) array_ |  |


#### MigrationSubStepsSpec



MigrationSubStepsSpec defines the desired state of MigrationSubSteps

_Appears in:_
- [MigrationSubSteps](#migrationsubsteps)

| Field | Description |
| --- | --- |
| `foo` _string_ | Foo is an example field of MigrationSubSteps. Edit MigrationSubSteps_types.go to remove/update |


#### MigrationSubStepsStatus



MigrationSubStepsStatus defines the observed state of MigrationSubSteps

_Appears in:_
- [MigrationStatus](#migrationstatus)
- [MigrationSubSteps](#migrationsubsteps)

| Field | Description |
| --- | --- |
| `currentOperationSubSteps` _[StepProgress](#stepprogress) array_ |  |


#### NfsMount





_Appears in:_
- [LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)

| Field | Description |
| --- | --- |
| `localPath` _string_ |  |
| `remotePath` _string_ |  |
| `server` _string_ |  |
| `mountOptions` _string array_ |  |


#### OpenPort





_Appears in:_
- [LinuxDiscoveryReportSpec](#linuxdiscoveryreportspec)

| Field | Description |
| --- | --- |
| `port` _integer_ |  |
| `protocol` _[Protocol](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#protocol-v1-core)_ |  |
| `programName` _string_ |  |


#### OperationInfo



OperationInfo holds operation status including error status

_Appears in:_
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)
- [DiscoveryTaskStatus](#discoverytaskstatus)
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [MigrationStatus](#migrationstatus)
- [SourceSnapshotStatus](#sourcesnapshotstatus)
- [VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)
- [WindowsGenerateArtifactsTaskStatus](#windowsgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `ErrorStatus` _[ErrorStatus](#errorstatus)_ |  |


#### OperationStatus

_Underlying type:_ `string`



_Appears in:_
- [AppXDiscoveryTaskStatus](#appxdiscoverytaskstatus)
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)
- [DiscoveryTaskStatus](#discoverytaskstatus)
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [MigrationStatus](#migrationstatus)
- [OperationInfo](#operationinfo)
- [StepProgress](#stepprogress)
- [VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)
- [WindowsDiscoveryStatus](#windowsdiscoverystatus)
- [WindowsGenerateArtifactsTaskStatus](#windowsgenerateartifactstaskstatus)



#### OsType

_Underlying type:_ `string`



_Appears in:_
- [AppXPluginSpec](#appxpluginspec)
- [MigrationSpec](#migrationspec)
- [SourceSnapshotSpec](#sourcesnapshotspec)



#### Parameter





_Appears in:_
- [AppXPluginSpec](#appxpluginspec)
- [MigrationSpec](#migrationspec)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `value` _string_ |  |


#### ParameterDef





_Appears in:_
- [AppXPluginSpec](#appxpluginspec)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `envVar` _string_ |  |
| `usage` _string_ |  |


#### PasswordRef





_Appears in:_
- [LocalVmwareSourceSpec](#localvmwaresourcespec)
- [MigrateForCEManagementDetails](#migrateforcemanagementdetails)

| Field | Description |
| --- | --- |
| `secretRef` _[SecretReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#secretreference-v1-core)_ |  |


#### PodStatus





_Appears in:_
- [AppXDataStatus](#appxdatastatus)
- [AppXDiscoveryTaskStatus](#appxdiscoverytaskstatus)
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)
- [DataStatus](#datastatus)
- [DiscoveryTaskStatus](#discoverytaskstatus)
- [ImageExtractionStatus](#imageextractionstatus)
- [ImageUploadStatus](#imageuploadstatus)
- [WindowsDiscoveryStatus](#windowsdiscoverystatus)
- [WindowsGenerateArtifactsTaskStatus](#windowsgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `pod` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `phase` _[PodPhase](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#podphase-v1-core)_ |  |
| `pod_creation_time` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |
| `pod_deletion_time` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |


#### Probes





_Appears in:_
- [Deployment](#deployment)

| Field | Description |
| --- | --- |
| `livenessProbe` _[Probe](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#probe-v1-core)_ |  |
| `readinessProbe` _[Probe](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#probe-v1-core)_ |  |
| `startupProbe` _[Probe](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#probe-v1-core)_ |  |


#### Pvc





_Appears in:_
- [DataVolume](#datavolume)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `spec` _[PersistentVolumeClaimSpec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolumeclaimspec-v1-core)_ |  |


#### PvcStatus





_Appears in:_
- [ComputeEngineSourceSnapshotStatus](#computeenginesourcesnapshotstatus)
- [Ec2VolumeStatus](#ec2volumestatus)
- [GceVolumeStatus](#gcevolumestatus)
- [LocalEc2SourceSnapshotStatus](#localec2sourcesnapshotstatus)
- [LocalVmwareSourceSnapshotStatus](#localvmwaresourcesnapshotstatus)
- [MigrateForCeStatus](#migrateforcestatus)



#### RemoteSourceSpec





_Appears in:_
- [SourceProviderSpec](#sourceproviderspec)

| Field | Description |
| --- | --- |
| `migrateForCEService` _[MigrateForCEService](#migrateforceservice)_ |  |


#### ReplicatingVM



ReplicatingVM is the Schema for the sourceproviders API

_Appears in:_
- [ReplicatingVMList](#replicatingvmlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `ReplicatingVM`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[ReplicatingVMSpec](#replicatingvmspec)_ |  |
| `status` _[ReplicatingVMStatus](#replicatingvmstatus)_ |  |


#### ReplicatingVMDefaults





_Appears in:_
- [MigrateForCEService](#migrateforceservice)

| Field | Description |
| --- | --- |
| `groupName` _string_ |  |
| `activeIdleDuration` _[Duration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#duration-v1-meta)_ |  |
| `inactiveIdleDuration` _[Duration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#duration-v1-meta)_ |  |
| `zone` _string_ |  |
| `network` _string_ |  |
| `subnet` _string_ |  |
| `machineType` _string_ |  |
| `machineTypeSeries` _string_ |  |
| `serviceAccount` _string_ |  |
| `targetProject` _string_ |  |


#### ReplicatingVMList



ReplicatingVMList contains a list of ReplicatingVM



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `ReplicatingVMList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[ReplicatingVM](#replicatingvm) array_ |  |


#### ReplicatingVMSpec





_Appears in:_
- [ReplicatingVM](#replicatingvm)

| Field | Description |
| --- | --- |
| `migrateForCEService` _[MigrateForCEService](#migrateforceservice)_ |  |
| `sourceID` _string_ |  |


#### ReplicatingVMState

_Underlying type:_ `string`



_Appears in:_
- [ReplicatingVMStatus](#replicatingvmstatus)



#### ReplicatingVMStatus





_Appears in:_
- [ReplicatingVM](#replicatingvm)

| Field | Description |
| --- | --- |
| `migratingVMID` _string_ |  |
| `state` _[ReplicatingVMState](#replicatingvmstate)_ |  |
| `lastKnownUsage` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |


#### RepositoryLocation





_Appears in:_
- [DeploymentStatus](#deploymentstatus)

| Field | Description |
| --- | --- |
| `gcs` _[GcsRepositoryLocation](#gcsrepositorylocation)_ |  |
| `s3` _[S3RepositoryLocation](#s3repositorylocation)_ |  |


#### S3CredentialsSpec





_Appears in:_
- [S3RespositorySpec](#s3respositoryspec)

| Field | Description |
| --- | --- |
| `secretRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### S3RepositoryLocation





_Appears in:_
- [RepositoryLocation](#repositorylocation)

| Field | Description |
| --- | --- |
| `bucket` _string_ |  |
| `region` _string_ |  |


#### S3RespositorySpec





_Appears in:_
- [ArtifactsRepositorySpec](#artifactsrepositoryspec)

| Field | Description |
| --- | --- |
| `region` _string_ | Valid S3 region. Used as session endpoint and bucket location hint. |
| `secretAccessKey` _[S3CredentialsSpec](#s3credentialsspec)_ | Optional credentials reference. |
| `bucket` _string_ | An S3 bucket, must already exist and be writeable. |


#### SourceProvider



SourceProvider is the Schema for the sourceproviders API

_Appears in:_
- [SourceProviderList](#sourceproviderlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `SourceProvider`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[SourceProviderSpec](#sourceproviderspec)_ |  |
| `status` _[SourceProviderStatus](#sourceproviderstatus)_ |  |


#### SourceProviderList



SourceProviderList contains a list of SourceProvider



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `SourceProviderList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[SourceProvider](#sourceprovider) array_ |  |


#### SourceProviderSpec



SourceProviderSpec defines the desired state of SourceProvider

_Appears in:_
- [SourceProvider](#sourceprovider)

| Field | Description |
| --- | --- |
| `migrateForCE` _[MigrateForCESourceSpec](#migrateforcesourcespec)_ |  |
| `LocalSourceSpec` _[LocalSourceSpec](#localsourcespec)_ |  |
| `remoteSourceSpec` _[RemoteSourceSpec](#remotesourcespec)_ |  |


#### SourceProviderStatus



SourceProviderStatus defines the observed state of SourceProvider

_Appears in:_
- [SourceProvider](#sourceprovider)

| Field | Description |
| --- | --- |
| `state` _SourceProviderState_ |  |
| `message` _string_ |  |
| `secretRef` _[SecretReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#secretreference-v1-core)_ |  |
| `storageClassRef` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### SourceSnapshot



SourceSnapshot is the Schema for the sourcesnapshots API.

_Appears in:_
- [SourceSnapshotList](#sourcesnapshotlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `SourceSnapshot`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[SourceSnapshotSpec](#sourcesnapshotspec)_ |  |
| `status` _[SourceSnapshotStatus](#sourcesnapshotstatus)_ |  |


#### SourceSnapshotList



SourceSnapshotList contains a list of SourceSnapshot.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `SourceSnapshotList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[SourceSnapshot](#sourcesnapshot) array_ |  |


#### SourceSnapshotSpec



SourceSnapshotSpec defines the desired state of SourceSnapshot.

_Appears in:_
- [MigrationSpec](#migrationspec)
- [SourceSnapshot](#sourcesnapshot)

| Field | Description |
| --- | --- |
| `sourceProvider` _string_ |  |
| `sourceId` _string_ |  |
| `computeEngineSourceSnapshot` _[ComputeEngineSourceSnapshot](#computeenginesourcesnapshot)_ |  |
| `osType` _[OsType](#ostype)_ |  |
| `migrateForCe` _[MigrateForCe](#migrateforce)_ |  |
| `remoteSourceSnapshot` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### SourceSnapshotStatus



SourceSnapshotStatus defines the observed state of SourceSnapshot.

_Appears in:_
- [SourceSnapshot](#sourcesnapshot)
- [SubResourceSourceSnapshotStatus](#subresourcesourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `computeEngine` _[ComputeEngineSourceSnapshotStatus](#computeenginesourcesnapshotstatus)_ |  |
| `localEc2` _[LocalEc2SourceSnapshotStatus](#localec2sourcesnapshotstatus)_ |  |
| `localVmware` _[LocalVmwareSourceSnapshotStatus](#localvmwaresourcesnapshotstatus)_ |  |
| `localOVF` _[LocalOVFSourceSnapshotStatus](#localovfsourcesnapshotstatus)_ |  |
| `ready` _boolean_ |  |
| `migrateForCe` _[MigrateForCeStatus](#migrateforcestatus)_ |  |
| `operation` _[OperationInfo](#operationinfo)_ |  |


#### StepProgress





_Appears in:_
- [MigrationSubStepsStatus](#migrationsubstepsstatus)

| Field | Description |
| --- | --- |
| `description` _SubStep_ |  |
| `status` _[OperationStatus](#operationstatus)_ | Make sure to copy from controllers/api/v1beta2/migrationsubsteps_types.go TODO: Test that all supported statuses are in this list |
| `progress` _string_ |  |


#### SubResourceAppXStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `discoveryStatus` _[AppXDiscoveryFlowStatus](#appxdiscoveryflowstatus)_ |  |
| `extractStatus` _[AppXGenerateArtifactsFlowStatus](#appxgenerateartifactsflowstatus)_ |  |


#### SubResourceDiscoveryStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `task` _[SubResourceDiscoveryTaskStatus](#subresourcediscoverytaskstatus)_ |  |
| `report` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### SubResourceDiscoveryTaskStatus





_Appears in:_
- [SubResourceDiscoveryStatus](#subresourcediscoverystatus)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[DiscoveryTaskStatus](#discoverytaskstatus)_ |  |


#### SubResourceGenerateArtifactsStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `task` _[SubResourceGenerateArtifactsTaskStatus](#subresourcegenerateartifactstaskstatus)_ |  |
| `alwaysRetakeSnapshot` _boolean_ |  |


#### SubResourceGenerateArtifactsTaskStatus





_Appears in:_
- [SubResourceGenerateArtifactsStatus](#subresourcegenerateartifactsstatus)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[GenerateArtifactsTaskStatus](#generateartifactstaskstatus)_ |  |


#### SubResourceSourceSnapshotStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[SourceSnapshotStatus](#sourcesnapshotstatus)_ |  |


#### SubResourceVmGenerateArtifactsStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `task` _[SubResourceVmGenerateArtifactsTaskStatus](#subresourcevmgenerateartifactstaskstatus)_ |  |
| `alwaysRetakeSnapshot` _boolean_ |  |


#### SubResourceVmGenerateArtifactsTaskStatus





_Appears in:_
- [SubResourceVmGenerateArtifactsStatus](#subresourcevmgenerateartifactsstatus)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)_ | no status yet |


#### SubResourceWindowsDiscoveryStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[WindowsDiscoveryStatus](#windowsdiscoverystatus)_ |  |


#### SubResourceWindowsGenerateArtifactsStatus





_Appears in:_
- [MigrationSubResources](#migrationsubresources)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `task` _[SubResourceWindowsGenerateArtifactsTaskStatus](#subresourcewindowsgenerateartifactstaskstatus)_ |  |


#### SubResourceWindowsGenerateArtifactsTaskStatus





_Appears in:_
- [SubResourceWindowsGenerateArtifactsStatus](#subresourcewindowsgenerateartifactsstatus)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[WindowsGenerateArtifactsTaskStatus](#windowsgenerateartifactstaskstatus)_ |  |


#### SystemService





_Appears in:_
- [DiscoveredSystemService](#discoveredsystemservice)
- [Image](#image)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `enabled` _boolean_ |  |
| `probed` _boolean_ |  |


#### TargetSystem





_Appears in:_
- [MigrationPlan](#migrationplan)

| Field | Description |
| --- | --- |
| `baseVersion` _string_ |  |
| `requirements` _string array_ |  |
| `warnings` _string array_ |  |




#### VMImage





_Appears in:_
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `imageRepository` _[ImageRepositoryRef](#imagerepositoryref)_ |  |
| `name` _string_ |  |


#### VMSpec





_Appears in:_
- [VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `bootLoader` _BootLoader_ |  |
| `guestOsType` _string_ |  |
| `numCpu` _integer_ |  |
| `ramMb` _integer_ |  |


#### VmGenerateArtifactsFlow



VmGenerateArtifactsFlow is the Schema for the VmGenerateArtifactsFlow API.

_Appears in:_
- [VmGenerateArtifactsFlowList](#vmgenerateartifactsflowlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `VmGenerateArtifactsFlow`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[VmGenerateArtifactsFlowSpec](#vmgenerateartifactsflowspec)_ |  |
| `status` _[VmGenerateArtifactsFlowStatus](#vmgenerateartifactsflowstatus)_ |  |


#### VmGenerateArtifactsFlowList



VmGenerateArtifactsFlowList contains a list of VmGenerateArtifactsFlow.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `VmGenerateArtifactsFlowList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[VmGenerateArtifactsFlow](#vmgenerateartifactsflow) array_ |  |


#### VmGenerateArtifactsFlowSpec



VmGenerateArtifactsFlowSpec defines the desired state of VmGenerateArtifactsFlow.

_Appears in:_
- [VmGenerateArtifactsFlow](#vmgenerateartifactsflow)

| Field | Description |
| --- | --- |
| `intent` _[Intent](#intent)_ |  |
| `image` _[VMImage](#vmimage)_ |  |
| `vmSpec` _[VMSpec](#vmspec)_ |  |
| `dataVolumes` _[DataVolume](#datavolume) array_ |  |
| `deployment` _[Deployment](#deployment)_ |  |
| `configs` _[Configs](#configs)_ |  |
| `diskPvcsNamespace` _string_ | Namespace in which to place the disk PVCs for data migrations. If empty "default" is used. |
| `storageClassName` _string_ | Storage class to use for output PVCs, if omitted the default storage class is used. |
| `targetDiskConfig` _[DiskConfig](#diskconfig)_ |  |




#### VmGenerateArtifactsTask



VmGenerateArtifactsTask is the Schema for the vmgenerateartifactstasks API.

_Appears in:_
- [VmGenerateArtifactsTaskList](#vmgenerateartifactstasklist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `VmGenerateArtifactsTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[VmGenerateArtifactsTaskSpec](#vmgenerateartifactstaskspec)_ |  |
| `status` _[VmGenerateArtifactsTaskStatus](#vmgenerateartifactstaskstatus)_ |  |


#### VmGenerateArtifactsTaskExportProgress



VmGenerateArtifactsTaskExportProgress tracks the progress of exporting the disks of a VM.

_Appears in:_
- [VmGenerateArtifactsTaskProgress](#vmgenerateartifactstaskprogress)

| Field | Description |
| --- | --- |
| `downloadProgressPercentage` _string_ | Percentage of total disks size that has been downloaded. Since downloading uses compression, will be an underestimate. |
| `bytesDownloadedByDisk` _object (keys:string, values:integer)_ | The number of bytes downloaded per disk. Key is index of each disk. |
| `totalDisksSize` _integer_ | Sum of size of all disks that will be downloaded in bytes. |
| `statusByDisk` _object (keys:string, values:[ExportProgressDiskStatus](#exportprogressdiskstatus))_ | Download status of each disk. Key is index of each disk. |


#### VmGenerateArtifactsTaskList



VmGenerateArtifactsTaskList contains a list of VmGenerateArtifactsTask.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `VmGenerateArtifactsTaskList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[VmGenerateArtifactsTask](#vmgenerateartifactstask) array_ |  |


#### VmGenerateArtifactsTaskProgress



VmGenerateArtifactsTaskProgress tracks the progress of a VmGenerateArtifactsTask.

_Appears in:_
- [VmGenerateArtifactsTaskProgressList](#vmgenerateartifactstaskprogresslist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `VmGenerateArtifactsTaskProgress`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `export` _[VmGenerateArtifactsTaskExportProgress](#vmgenerateartifactstaskexportprogress)_ |  |


#### VmGenerateArtifactsTaskProgressList



VmGenerateArtifactsTaskProgressList contains a list of VmGenerateArtifactsTaskProgress.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `VmGenerateArtifactsTaskProgressList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[VmGenerateArtifactsTaskProgress](#vmgenerateartifactstaskprogress) array_ |  |


#### VmGenerateArtifactsTaskSpec



VmGenerateArtifactsTaskSpec defines the desired state of VmGenerateArtifactsTask.

_Appears in:_
- [VmGenerateArtifactsTask](#vmgenerateartifactstask)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### VmGenerateArtifactsTaskStatus



VmGenerateArtifactsTaskStatus defines the observed state of VmGenerateArtifactsTask.

_Appears in:_
- [SubResourceVmGenerateArtifactsTaskStatus](#subresourcevmgenerateartifactstaskstatus)
- [VmGenerateArtifactsTask](#vmgenerateartifactstask)

| Field | Description |
| --- | --- |
| `data` _[DataStatus](#datastatus)_ |  |
| `image` _[ImageStatus](#imagestatus)_ |  |
| `deployment` _[DeploymentStatus](#deploymentstatus)_ |  |
| `progress` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `operation` _[OperationInfo](#operationinfo)_ |  |
| `deletedOldSnapshot` _boolean_ |  |


#### VmwareDiskInfo





_Appears in:_
- [VmwareHardwareSpec](#vmwarehardwarespec)



#### VmwareHardwareSpec





_Appears in:_
- [LocalOVFSourceSnapshotStatus](#localovfsourcesnapshotstatus)
- [LocalVmwareSourceSnapshotStatus](#localvmwaresourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `firmware` _string_ |  |
| `efiSecureBoot` _boolean_ |  |
| `guestOsId` _string_ |  |
| `numCpu` _integer_ |  |
| `ramMb` _integer_ |  |
| `uuid` _string_ |  |
| `instanceUuid` _string_ |  |
| `disksInfo` _[VmwareDiskInfo](#vmwarediskinfo) array_ |  |


#### VmwareTaskTracker





_Appears in:_
- [VmwareTracker](#vmwaretracker)



#### VmwareTracker





_Appears in:_
- [LocalVmwareSourceSnapshotStatus](#localvmwaresourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `create` _[VmwareTaskTracker](#vmwaretasktracker)_ |  |
| `cleanup` _[VmwareTaskTracker](#vmwaretasktracker)_ |  |


#### Volume





_Appears in:_
- [ComputeEngineSourceSnapshot](#computeenginesourcesnapshot)
- [ComputeEngineSourceSnapshotStatus](#computeenginesourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `zone` _string_ |  |
| `name` _string_ |  |


#### VolumeSpec





_Appears in:_
- [GenerateArtifactsFlowStatus](#generateartifactsflowstatus)

| Field | Description |
| --- | --- |
| `pvc` _[PersistentVolumeClaim](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolumeclaim-v1-core)_ |  |
| `pv` _[PersistentVolume](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolume-v1-core)_ |  |


#### Warning





_Appears in:_
- [AppXDiscoveryFlowSpec](#appxdiscoveryflowspec)
- [AppXDiscoveryResultSpec](#appxdiscoveryresultspec)
- [AppXGenerateArtifactsFlowSpec](#appxgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `message` _string_ | 'Message' is human-readable information |
| `mitigation` _string_ | 'Mitigation' is human-readable information |
| `reason` _string_ | 'Reason' is short and unique, UpperCamelCase |
| `type` _string_ | 'Type' is either Normal / MigrationBlocker |


#### WindowsArtifacts





_Appears in:_
- [WindowsGenerateArtifactsTaskStatus](#windowsgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `repositoryBucket` _string_ |  |
| `repositoryFolder` _string_ |  |
| `artifactsZip` _string_ |  |


#### WindowsDiscovery



WindowsDiscovery is the Schema for the windowsdiscoveries API

_Appears in:_
- [WindowsDiscoveryList](#windowsdiscoverylist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsDiscovery`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[WindowsDiscoverySpec](#windowsdiscoveryspec)_ |  |
| `status` _[WindowsDiscoveryStatus](#windowsdiscoverystatus)_ |  |


#### WindowsDiscoveryList



WindowsDiscoveryList contains a list of WindowsDiscovery



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsDiscoveryList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[WindowsDiscovery](#windowsdiscovery) array_ |  |


#### WindowsDiscoveryResult



WindowsDiscoveryResult is the Schema for the windowsdiscoveryresults API

_Appears in:_
- [WindowsDiscoveryResultList](#windowsdiscoveryresultlist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsDiscoveryResult`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[WindowsDiscoveryResultSpec](#windowsdiscoveryresultspec)_ |  |
| `status` _[WindowsDiscoveryResultStatus](#windowsdiscoveryresultstatus)_ |  |


#### WindowsDiscoveryResultList



WindowsDiscoveryResultList contains a list of WindowsDiscoveryResult



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsDiscoveryResultList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[WindowsDiscoveryResult](#windowsdiscoveryresult) array_ |  |


#### WindowsDiscoveryResultSpec



WindowsDiscoveryResultSpec defines the desired state of WindowsDiscoveryResult

_Appears in:_
- [WindowsDiscoveryResult](#windowsdiscoveryresult)

| Field | Description |
| --- | --- |
| `migrationPlanYaml` _string_ |  |
| `error` _string_ |  |






#### WindowsDiscoveryStatus



WindowsDiscoveryStatus defines the observed state of WindowsDiscovery

_Appears in:_
- [SubResourceWindowsDiscoveryStatus](#subresourcewindowsdiscoverystatus)
- [WindowsDiscovery](#windowsdiscovery)

| Field | Description |
| --- | --- |
| `discover` _[PodStatus](#podstatus)_ |  |
| `windowsDiscoveryResult` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `windowsGenerateArtifacts` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `error` _string_ |  |


#### WindowsGenerateArtifacts



WindowsGenerateArtifacts is the Schema for the windowsgenerateartifacts API

_Appears in:_
- [WindowsGenerateArtifactsList](#windowsgenerateartifactslist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsGenerateArtifacts`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[WindowsGenerateArtifactsSpec](#windowsgenerateartifactsspec)_ |  |
| `status` _[WindowsGenerateArtifactsStatus](#windowsgenerateartifactsstatus)_ |  |


#### WindowsGenerateArtifactsList



WindowsGenerateArtifactsList contains a list of WindowsGenerateArtifacts



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsGenerateArtifactsList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[WindowsGenerateArtifacts](#windowsgenerateartifacts) array_ |  |


#### WindowsGenerateArtifactsSpec



WindowsGenerateArtifactsSpec defines the desired state of WindowsGenerateArtifacts

_Appears in:_
- [WindowsGenerateArtifacts](#windowsgenerateartifacts)

| Field | Description |
| --- | --- |
| `migrationPlan` _[MigrationPlan](#migrationplan)_ |  |
| `artifactsRepository` _[ArtifactsRepositoryRef](#artifactsrepositoryref)_ |  |
| `folder` _string_ |  |




#### WindowsGenerateArtifactsTask



WindowsGenerateArtifactsTask is the Schema for the windowsgenerateartifactstasks API

_Appears in:_
- [WindowsGenerateArtifactsTaskList](#windowsgenerateartifactstasklist)

| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsGenerateArtifactsTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[WindowsGenerateArtifactsTaskSpec](#windowsgenerateartifactstaskspec)_ |  |
| `status` _[WindowsGenerateArtifactsTaskStatus](#windowsgenerateartifactstaskstatus)_ |  |


#### WindowsGenerateArtifactsTaskList



WindowsGenerateArtifactsTaskList contains a list of WindowsGenerateArtifactsTask



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `WindowsGenerateArtifactsTaskList`
| `metadata` _[ListMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#listmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `items` _[WindowsGenerateArtifactsTask](#windowsgenerateartifactstask) array_ |  |


#### WindowsGenerateArtifactsTaskSpec



WindowsGenerateArtifactsTaskSpec defines the desired state of WindowsGenerateArtifactsTask

_Appears in:_
- [WindowsGenerateArtifactsTask](#windowsgenerateartifactstask)

| Field | Description |
| --- | --- |
| `migration` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |


#### WindowsGenerateArtifactsTaskStatus



WindowsGenerateArtifactsTaskStatus defines the observed state of WindowsGenerateArtifactsTask

_Appears in:_
- [SubResourceWindowsGenerateArtifactsTaskStatus](#subresourcewindowsgenerateartifactstaskstatus)
- [WindowsGenerateArtifactsTask](#windowsgenerateartifactstask)

| Field | Description |
| --- | --- |
| `extract` _[PodStatus](#podstatus)_ |  |
| `artifacts` _[WindowsArtifacts](#windowsartifacts)_ |  |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `operation` _[OperationInfo](#operationinfo)_ | Note: both Operation and Status hold OperationStatus. Operation.Status is used for maintaining error state. Status is used for internal state management. |



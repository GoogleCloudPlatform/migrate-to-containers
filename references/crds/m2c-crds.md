# API Reference

## Packages
- [anthos-migrate.cloud.google.com/v1](#anthos-migratecloudgooglecomv1)
- [anthos-migrate.cloud.google.com/v1beta2](#anthos-migratecloudgooglecomv1beta2)


## anthos-migrate.cloud.google.com/v1

Package v1 contains API Schema definitions for the anthos-migrate.cloud.google.com v1 API group

### Resource Types
- [Migration](#migration)



#### Migration



Migration is the Schema for the migrations API



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


#### MigrationSpec



MigrationSpec defines the desired state of a Migration. This object is immutable, once all the parameters are set.

_Appears in:_
- [Migration](#migration)

| Field | Description |
| --- | --- |
| `type` _string_ | Type describes the type of migration, available values are dependant on what AppX plugins are installed in the current cluster. |
| `discoveryParameters` _[Parameter](#parameter) array_ | Optional configuration for this migration |
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


#### Parameter





_Appears in:_
- [MigrationSpec](#migrationspec)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the Parameter. Must contain only alphanumeric characters ([a-z0-9A-Z]) or underscores (_). Must match the name of existing ParameterDef. |
| `value` _string_ | Value of the parameter. |


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
- [AppXGenerateArtifactsFlow](#appxgenerateartifactsflow)
- [AppXGenerateArtifactsTask](#appxgenerateartifactstask)
- [AppXPlugin](#appxplugin)
- [ArtifactsRepository](#artifactsrepository)
- [ImageRepository](#imagerepository)
- [SourceProvider](#sourceprovider)



#### AppXDataStatus





_Appears in:_
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)

| Field | Description |
| --- | --- |
| `pod` _[PodStatus](#podstatus)_ |  |


#### AppXExistingPvc





_Appears in:_
- [AppXVolume](#appxvolume)

| Field | Description |
| --- | --- |
| `LocalObjectReference` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `subPath` _[string](#string)_ |  |


#### AppXGenerateArtifactsFlow



AppXGenerateArtifactsFlow is the Schema for the appxgenerateartifactsflows API



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXGenerateArtifactsFlow`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXGenerateArtifactsFlowSpec](#appxgenerateartifactsflowspec)_ |  |


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




#### AppXGenerateArtifactsTask



AppXGenerateArtifactsTask is the Schema for the appxgenerateartifactstasks API



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXGenerateArtifactsTask`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXGenerateArtifactsTaskSpec](#appxgenerateartifactstaskspec)_ |  |
| `status` _[AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)_ |  |


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



AppXPlugin describes the discovery and extraction images used for application migration.



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `AppXPlugin`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[AppXPluginSpec](#appxpluginspec)_ | Specification of the desired behavior of AppXPlugin. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status |
| `status` _[AppXPluginStatus](#appxpluginstatus)_ | Most recently observed status of AppXPlugin. This data may not be up to date. Populated by the system. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status |


#### AppXPluginSpec



AppXPluginSpec is a description of AppXPlugin.

_Appears in:_
- [AppXPlugin](#appxplugin)

| Field | Description |
| --- | --- |
| `compatibleVersion` _string_ | CompatibleVersion is the minimal Migrate to Containers version that is compatible with the AppXPlugin. |
| `discoverImage` _string_ | Name of the Discover container image. More info: https://kubernetes.io/docs/concepts/containers/images/#image-names |
| `discoverCommand` _string array_ | Entrypoint array for the Discover container. |
| `generateArtifactsImage` _string_ | Name of the GenerateArtifacts container image. More info: https://kubernetes.io/docs/concepts/containers/images/#image-names |
| `generateArtifactsCommand` _string array_ | Entrypoint array for the GenerateArtifacts container. |
| `imagePullSecrets` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core) array_ | ImagePullSecrets is an optional list of references to secrets in the same namespace, used for pulling any of the images used by Discover and GenerateArtifacts pods. More info: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod |
| `validationSchema` _string_ | JSON scheme used for validating the scheme of the AppXPlugin. More info: http://json-schema.org |
| `osType` _[OsType](#ostype)_ | Specifies the OS of VMs that are suitable for migration using the AppXPlugin. Valid options are: Linux, Windows. Defaults to Linux. |
| `parameterDefs` _[ParameterDef](#parameterdef) array_ | ParameterDef list. Defines environment variables that can be used by the Discover and GenerateArtifacts containers. |
| `defaultArguments` _[Parameter](#parameter) array_ | Parameter list. Sets default values of environment variable defined by ParameterDefs. |




#### AppXRepositoryDelivery



AppXRepositoryDelivery is not a standalone CRD, but rather a field contained in discovery and extract task statuses to describe their produced items for posterity

_Appears in:_
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




#### ArtifactsRepository



ArtifactsRepository is the Schema for the artifactsrepositories API



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


#### ArtifactsRepositoryRef





_Appears in:_
- [MigrationSpec](#migrationspec)

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


#### DataConfig





_Appears in:_
- [AppXGenerateArtifactsFlowSpec](#appxgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `volumes` _[AppXVolume](#appxvolume) array_ |  |
















#### Ec2SnapshotInfo





_Appears in:_
- [Ec2VolumeStatus](#ec2volumestatus)

| Field | Description |
| --- | --- |
| `id` _string_ |  |
| `state` _string_ |  |


#### Ec2VolumeInfo





_Appears in:_
- [Ec2VolumeStatus](#ec2volumestatus)

| Field | Description |
| --- | --- |
| `id` _string_ |  |
| `state` _string_ |  |


#### Ec2VolumeStatus





_Appears in:_
- [LocalEc2SourceSnapshotStatus](#localec2sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `pvc` _[PvcStatus](#pvcstatus)_ |  |
| `copiedDisk` _[Ec2VolumeInfo](#ec2volumeinfo)_ |  |
| `snapshot` _[Ec2SnapshotInfo](#ec2snapshotinfo)_ |  |




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

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `zone` _string_ |  |
| `operationName` _string_ |  |
| `operationType` _string_ |  |
| `progress` _integer_ |  |
| `status` _GceResourceOperationStatus_ |  |
| `statusMessage` _string_ |  |
| `errors` _string_ |  |
| `warnings` _string_ |  |
| `startTime` _string_ |  |
| `endTime` _string_ |  |


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








#### HTTPConfigSpec





_Appears in:_
- [LocalOVFSourceSpec](#localovfsourcespec)

| Field | Description |
| --- | --- |
| `ignoreCert` _boolean_ |  |




#### ImageRepository



ImageRepository is the Schema for the imagerepositories API



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
| `secret` _[string](#string)_ |  |


#### ImageRepositoryCredentialsType

_Underlying type:_ `string`



_Appears in:_
- [ImageRepositoryCredentials](#imagerepositorycredentials)



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
| `createPvcs` _[PvcStatus](#pvcstatus) array_ |  |
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
















#### OperationInfo



OperationInfo holds operation status including error status

_Appears in:_
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)
- [DiscoveryTaskStatus](#discoverytaskstatus)
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [MigrationStatus](#migrationstatus)
- [SourceSnapshotStatus](#sourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `status` _[OperationStatus](#operationstatus)_ |  |
| `ErrorStatus` _[ErrorStatus](#errorstatus)_ |  |


#### OperationStatus

_Underlying type:_ `string`



_Appears in:_
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)
- [DiscoveryTaskStatus](#discoverytaskstatus)
- [GenerateArtifactsTaskStatus](#generateartifactstaskstatus)
- [MigrationStatus](#migrationstatus)
- [OperationInfo](#operationinfo)
- [StepProgress](#stepprogress)



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
| `name` _string_ | Name of the Parameter. Must contain only alphanumeric characters ([a-z0-9A-Z]) or underscores (_). Must match the name of existing ParameterDef. |
| `value` _string_ | Value of the parameter. |


#### ParameterDef





_Appears in:_
- [AppXPluginSpec](#appxpluginspec)

| Field | Description |
| --- | --- |
| `name` _string_ | Name of the ParameterDef. Must contain only alphanumeric characters ([a-z0-9A-Z]) or underscores (_). |
| `envVar` _string_ | Name of the environment variable. Seen by the Discover and GenerateArtifacts containers. Must be a C_IDENTIFIER ([A-Za-z_][A-Za-z0-9_]*). It is recommended to use a unique name, prefixed by the AppXPlugin provider domain and AppXPlugin names. |
| `usage` _string_ | Description of the ParameterDef in plain text. |


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
- [AppXGenerateArtifactsTaskStatus](#appxgenerateartifactstaskstatus)
- [DiscoveryTaskStatus](#discoverytaskstatus)
- [ImageUploadStatus](#imageuploadstatus)

| Field | Description |
| --- | --- |
| `pod` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |
| `phase` _[PodPhase](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#podphase-v1-core)_ |  |
| `pod_creation_time` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |
| `pod_deletion_time` _[Time](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#time-v1-meta)_ |  |




#### PvcStatus





_Appears in:_
- [ComputeEngineSourceSnapshotStatus](#computeenginesourcesnapshotstatus)
- [Ec2VolumeStatus](#ec2volumestatus)
- [GceVolumeStatus](#gcevolumestatus)
- [LocalEc2SourceSnapshotStatus](#localec2sourcesnapshotstatus)
- [LocalVmwareSourceSnapshotStatus](#localvmwaresourcesnapshotstatus)
- [MigrateForCeStatus](#migrateforcestatus)

| Field | Description |
| --- | --- |
| `name` _string_ |  |
| `claimPhase` _[PersistentVolumeClaimPhase](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#persistentvolumeclaimphase-v1-core)_ |  |
| `resourcePath` _string_ | Original resource path in cloud (VMware disk path, gce disk name, pv name etc). |
| `pvName` _string_ | PV Name. |
| `created` _boolean_ | Was the PVC created. |
| `csiPvc` _boolean_ | A flag indicating whether the PVC represents a V2K CSI PVC. |


#### RemoteSourceSpec





_Appears in:_
- [SourceProviderSpec](#sourceproviderspec)

| Field | Description |
| --- | --- |
| `migrateForCEService` _[MigrateForCEService](#migrateforceservice)_ |  |


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



| Field | Description |
| --- | --- |
| `apiVersion` _string_ | `anthos-migrate.cloud.google.com/v1beta2`
| `kind` _string_ | `SourceProvider`
| `metadata` _[ObjectMeta](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#objectmeta-v1-meta)_ | Refer to Kubernetes API documentation for fields of `metadata`. |
| `spec` _[SourceProviderSpec](#sourceproviderspec)_ |  |
| `status` _[SourceProviderStatus](#sourceproviderstatus)_ |  |


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


#### SourceSnapshotSpec



SourceSnapshotSpec defines the desired state of SourceSnapshot.

_Appears in:_
- [MigrationSpec](#migrationspec)

| Field | Description |
| --- | --- |
| `sourceProvider` _string_ |  |
| `sourceId` _string_ |  |
| `computeEngineSourceSnapshot` _[ComputeEngineSourceSnapshot](#computeenginesourcesnapshot)_ |  |
| `osType` _[OsType](#ostype)_ |  |
| `migrateForCe` _[MigrateForCe](#migrateforce)_ |  |
| `remoteSourceSnapshot` _[LocalObjectReference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.22/#localobjectreference-v1-core)_ |  |












#### Volume





_Appears in:_
- [ComputeEngineSourceSnapshot](#computeenginesourcesnapshot)
- [ComputeEngineSourceSnapshotStatus](#computeenginesourcesnapshotstatus)

| Field | Description |
| --- | --- |
| `zone` _string_ |  |
| `name` _string_ |  |


#### Warning





_Appears in:_
- [AppXGenerateArtifactsFlowSpec](#appxgenerateartifactsflowspec)

| Field | Description |
| --- | --- |
| `message` _string_ | 'Message' is human-readable information |
| `mitigation` _string_ | 'Mitigation' is human-readable information |
| `reason` _string_ | 'Reason' is short and unique, UpperCamelCase |
| `type` _string_ | 'Type' is either Normal / MigrationBlocker |



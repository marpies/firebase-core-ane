# FirebaseCore | Extension for Adobe AIR (iOS & Android)

Extension providing common dependencies required for other Firebase services.

Development of this extension is supported by [Master Tigra, Inc.](https://github.com/mastertigra)

## Firebase SDK versions

* iOS `v3.4.0`
* Android `v9.4.0`

## Getting started

* For Android support, include [FirebaseConfig extension](https://github.com/marpies/firebase-config-ane) in your project.
* For iOS support, make sure you include `GoogleService-Info.plist` in the root of your IPA.

### Additions to AIR descriptor

Add the FirebaseCore extension ID to the `extensions` element.

```xml
<extensions>
    <extensionID>com.marpies.ane.firebase.core</extensionID>
</extensions>
```

If you are targeting Android, add the following extensions from [this repository](https://github.com/marpies/android-dependency-anes) as well (unless you know these libraries are included by some other extension):

```xml
<extensions>
    <extensionID>com.marpies.ane.androidsupport</extensionID>
    <extensionID>com.marpies.ane.googleplayservices.basement</extensionID>
    <extensionID>com.marpies.ane.googleplayservices.tasks</extensionID>
</extensions>
```

Modify the `manifestAdditions` so that it contains the following permissions, activites and meta data:

```xml
<android>
    <manifestAdditions>
        <![CDATA[
        <manifest android:installLocation="auto">
            <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
            <uses-permission android:name="android.permission.INTERNET" />
            <uses-permission android:name="android.permission.WAKE_LOCK" />
            <uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />

            <permission android:name="{APP-PACKAGE-NAME}.permission.C2D_MESSAGE"
                android:protectionLevel="signature" />

            <uses-permission android:name="{APP-PACKAGE-NAME}.permission.C2D_MESSAGE" />

            <application>

                <!-- gps basement -->
                <meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />

                <!-- firebase instance id -->
                <receiver
                    android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver"
                    android:exported="true"
                    android:permission="com.google.android.c2dm.permission.SEND" >
                    <intent-filter>
                        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
                        <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
                        <category android:name="{APP-PACKAGE-NAME}" />
                    </intent-filter>
                </receiver>

                <!-- Internal (not exported) receiver used by the app to start its own exported services
                     without risk of being spoofed. -->
                <receiver
                    android:name="com.google.firebase.iid.FirebaseInstanceIdInternalReceiver"
                    android:exported="false" />

                <!-- FirebaseInstanceIdService performs security checks at runtime,
                     no need for explicit permissions despite exported="true" -->
                <service
                    android:name="com.google.firebase.iid.FirebaseInstanceIdService"
                    android:exported="true">
                    <intent-filter android:priority="-500">
                        <action android:name="com.google.firebase.INSTANCE_ID_EVENT" />
                    </intent-filter>
                </service>

                <!-- firebase common -->
                <provider
                    android:authorities="{APP-PACKAGE-NAME}.firebaseinitprovider"
                    android:name="com.google.firebase.provider.FirebaseInitProvider"
                    android:exported="false"
                    android:initOrder="100" />

                <!-- firebase analytics -->
                <receiver
                    android:name="com.google.android.gms.measurement.AppMeasurementReceiver"
                    android:enabled="true">
                    <intent-filter>
                        <action android:name="com.google.android.gms.measurement.UPLOAD"/>
                    </intent-filter>
                </receiver>

                <service
                    android:name="com.google.android.gms.measurement.AppMeasurementService"
                    android:enabled="true"
                    android:exported="false"/>

            </application>

        </manifest>
        ]]>
    </manifestAdditions>
</android>
```

In the snippet above, replace `{APP-PACKAGE-NAME}` with your app package name (value of `id` element in your AIR app descriptor). Remember it's prefixed with `air.` when packaged by AIR SDK, unless you knowingly prevent this.

After your descriptor is set up, add the [FirebaseCore ANE](bin/com.marpies.ane.firebase.core.ane) or [SWC](bin/com.marpies.ane.firebase.core.swc) package from the [bin directory](bin/) to your project so that your IDE can work with it. The Android-only ANEs are only necessary during packaging.

## API overview

The extension's API exposes single method. It's recommended to call it soon after your app is launched, ideally in the constructor of your document class.

```as3
FirebaseCore.configure();
```

Other Firebase services are available for use immediately after the call, provided the configuration was successful. You may pass in `true` to the method call to see a native log message in cases when the Firebase SDK could not be configured for your app, most likely due to corrupted or missing configuration file.

## Build ANE
ANT build scripts are available in the [build](build/) directory. Edit [build.properties](build/build.properties) to correspond with your local setup.

## Author
The ANE has been written by [Marcel Piestansky](https://twitter.com/marpies) and is distributed under [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

## Changelog

#### August 16, 2016 (v1.0.0)

* Public release

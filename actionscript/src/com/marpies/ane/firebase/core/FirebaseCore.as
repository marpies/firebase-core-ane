/**
 * Copyright 2016 Marcel Piestansky (http://marpies.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.marpies.ane.firebase.core {

    CONFIG::ane {
        import flash.external.ExtensionContext;
    }

    import flash.system.Capabilities;

    public class FirebaseCore {

        private static const TAG:String = "[FirebaseCore]";
        private static const EXTENSION_ID:String = "com.marpies.ane.firebase.core";
        private static const iOS:Boolean = Capabilities.manufacturer.indexOf( "iOS" ) > -1;
        private static const ANDROID:Boolean = Capabilities.manufacturer.indexOf( "Android" ) > -1;

        CONFIG::ane {
            private static var mContext:ExtensionContext;
        }

        /* Event codes */

        /* Misc */
        private static var mLogEnabled:Boolean;

        /**
         * @private
         * Do not use. FirebaseCore is a static class.
         */
        public function FirebaseCore() {
            throw Error( "FirebaseCore is static class." );
        }

        /**
         *
         *
         * Public API
         *
         *
         */

        /**
         * Configures a default Firebase app. This method should be called as early as possible after the app is launched
         * and before using any other Firebase services.
         * 
         * @param showLogs Set to <code>true</code> to enable native logs. This may help you find out if there was an error configuring Firebase for your app.
         */
        public static function configure( showLogs:Boolean = false ):void {
            if( !isSupported ) return;

            mLogEnabled = showLogs;

            /* Initialize context */
            if( !initExtensionContext() ) {
                log( "Error creating extension context for " + EXTENSION_ID );
                return;
            }

            /* Call configure */
            CONFIG::ane {
                mContext.call( "configure", showLogs );
            }
        }

        /**
         * Disposes native extension context.
         */
        public static function dispose():void {
            if( !isSupported ) return;
            validateExtensionContext();

            CONFIG::ane {
                mContext.dispose();
                mContext = null;
            }
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Extension version.
         */
        public static function get version():String {
            return "1.0.0";
        }

        /**
         * Supported on iOS and Android.
         */
        public static function get isSupported():Boolean {
            return iOS || ANDROID;
        }

        /**
         *
         *
         * Private API
         *
         *
         */

        /**
         * Initializes extension context.
         * @return <code>true</code> if initialized successfully, <code>false</code> otherwise.
         */
        private static function initExtensionContext():Boolean {
            var result:Boolean;
            CONFIG::ane {
                if( mContext === null ) {
                    mContext = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
                }
                result = mContext !== null;
            }
            return result;
        }

        private static function validateExtensionContext():void {
            CONFIG::ane {
                if( !mContext ) throw new Error( "FirebaseCore extension was not initialized. Call init() first." );
            }
        }

        private static function log( message:String ):void {
            if( mLogEnabled ) {
                trace( TAG, message );
            }
        }

    }
}

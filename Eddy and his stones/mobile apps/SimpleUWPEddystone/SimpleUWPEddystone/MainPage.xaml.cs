using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using Windows.Devices.Bluetooth;
using Windows.Devices.Bluetooth.Advertisement;
using UniversalBeaconLibrary.Annotations;
using UniversalBeaconLibrary.Beacon;
using System.Diagnostics;

namespace SimpleUWPEddystone
{

    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        // Bluetooth Beacons
        private readonly BluetoothLEAdvertisementWatcher watcher;
        private readonly BeaconManager beaconManager;

        /**
         * Default constructor
         **/
        public MainPage()
        {
            this.InitializeComponent();

            // init beacon manager
            beaconManager = new BeaconManager();

            // create and start the (W10 UWP) BLE watcher
            watcher = new BluetoothLEAdvertisementWatcher { ScanningMode = BluetoothLEScanningMode.Active };

            // trigger following method when we receive data
            watcher.Received += WatcherOnReceived;

            // start watching
            watcher.Start();
        }

        /**
         * Triggered when we receive data
         **/
        private async void WatcherOnReceived(BluetoothLEAdvertisementWatcher sender, BluetoothLEAdvertisementReceivedEventArgs eventArgs)
        {
            // Let the library manager handle the advertisement to analyse & store the advertisement
            beaconManager.ReceivedAdvertisement(eventArgs);
        }

        private void btnSearchClick(object sender, RoutedEventArgs e)
        {

            // iterate over beacons we have found
            foreach (var bluetoothBeacon in beaconManager.BluetoothBeacons.ToList())
            {
                // if the beacon is type eddystone
                if (bluetoothBeacon.BeaconType == Beacon.BeaconTypeEnum.Eddystone)
                {

                    // update labels
                    txtEddystoneID.Text = bluetoothBeacon.BluetoothAddressAsString;
                    txtEddystoneRSSI.Text = bluetoothBeacon.Rssi.ToString();

                    // iterate over frames
                    foreach (var beaconFrame in bluetoothBeacon.BeaconFrames.ToList())
                    {
                        // be sure we are receiving an URL frame
                        if (beaconFrame is UrlEddystoneFrame)
                        {
                            txtEddystoneURL.Text = ((UrlEddystoneFrame)beaconFrame).CompleteUrl;
                        }
                    }
                }
            }
        }


    }
}

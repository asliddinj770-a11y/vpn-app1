import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class MyVPNApp extends StatefulWidget {
  const MyVPNApp({super.key});

  @override
  State<MyVPNApp> createState() => _MyVPNAppState();
}

class _MyVPNAppState extends State<MyVPNApp> {
  late OpenVPN vpnEngine;
  String status = "Ulanmagan";

  @override
  void initState() {
    super.initState();
    vpnEngine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (stage, raw) {
        setState(() {
          status = stage;
        });
      },
    );

    vpnEngine.initialize(
      groupIdentifier: "MyVPNApp",
      providerBundleIdentifier: "com.example.myvpnapp",
      localizedDescription: "MyVPN App bilan ulash",
    );
  }

  void connectVPN() async {
    await vpnEngine.connect(
      config: """ 
client
dev tun
proto udp
remote YOUR_SERVER_IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
cipher AES-256-CBC
verb 3
<ca>
-----BEGIN CERTIFICATE-----
PASTE_CA_CERT_HERE
-----END CERTIFICATE-----
</ca>
""",
      username: "vpnuser",
      password: "vpnpassword",
    );
  }

  void disconnectVPN() {
    vpnEngine.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MyVPN App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Status: $status"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectVPN,
              child: const Text("VPN ULASH"),
            ),
            ElevatedButton(
              onPressed: disconnectVPN,
              child: const Text("VPN O‘CHIRISH"),
            ),
          ],
        ),
      ),
    );
  }
}

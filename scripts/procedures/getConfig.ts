import { compat } from "../deps.ts";

export const [getConfig, setConfigMatcher] = compat.getConfigAndMatcher(
  {
    "webapi-tor-address": {
      name: "Web API Tor Address",
      description: "The Tor address of the Web API interface",
      type: "pointer",
      subtype: "package",
      "package-id": "wasabi-backend",
      target: "tor-address",
      interface: "main",
    },
    bitcoinrpcuser: {
      type: "pointer",
      name: "RPC Username",
      description: "The username for Bitcoin Core's RPC interface",
      subtype: "package",
      "package-id": "bitcoind",
      target: "config",
      multi: false,
      selector: "$.rpc.username",
    },
    bitcoinrpcpassword: {
      type: "pointer",
      name: "RPC Password",
      description: "The password for Bitcoin Core's RPC interface",
      subtype: "package",
      "package-id": "bitcoind",
      target: "config",
      multi: false,
      selector: "$.rpc.password",
    },
    enablecoordinator: {
      type: "boolean",
      name: "Enable Coinjoin Coordinator",
      desription: "Enable the Coinjoin Coordinator",
      warning:
        '<p>These terms and conditions govern your use of the Coinjoin Coordinator service. By using the service, you agree to be bound by these terms and conditions. If you do not agree to these terms and conditions, you should not use the service.</p><p>Coinjoin Coordinator Service: The Coinjoin Coordinator service is a tool that allows users to anonymize their cryptocurrency transactions by pooling them with other users\' funds and sending them within a common transaction. The service does not store, transmit, or otherwise handle users\' cryptocurrency funds.</p><p>Legal Compliance: You are responsible for complying with all applicable laws and regulations in your jurisdiction in relation to your use of the Coinjoin Coordinator service. The service is intended to be used for lawful purposes only.</p><p>No Warranty: The Coinjoin Coordinator service is provided on an "as is" and "as available" basis, without any warranty of any kind, either express or implied, including but not limited to the implied warranties of merchantability and fitness for a particular purpose.</p><p>Limitation of Liability: In no event shall the Coinjoin Coordinator be liable for any direct, indirect, incidental, special, or consequential damages, or loss of profits, arising out of or in connection with your use of the service.</p><p>Indemnification: You agree to indemnify and hold the Coinjoin Coordinator, its affiliates, officers, agents, and employees harmless from any claim or demand, including reasonable attorneys\' fees, made by any third party due to or arising out of your use of the service, your violation of these terms and conditions, or your violation of any rights of another.</p><p>Severability: If any provision of these terms and conditions is found to be invalid or unenforceable, the remaining provisions shall remain in full force and effect.</p><p>Governing Law: These terms and conditions shall be governed by and construed in accordance with the laws of the jurisdiction in which the Coinjoin Coordinator is based.</p><p>Changes to Terms and Conditions: Coinjoin Coordinator reserves the right, at its sole discretion, to modify or replace these terms and conditions at any time.</p>',
      default: false,
    },
    coordinator: {
      type: "object",
      name: "Coordinator settings",
      description: "WabiSabi Coordinator settings",
      spec: {
        coordinatorExtPubKey: {
          type: "string",
          name: "Coordinator BIP32 xpub",
          description: "BIP32 extended public key (xpub) of the coordinator",
          nullable: true,
          pattern: "^xpub.*$",
          "pattern-description": "BIP32 Extended public key (xpub)",
        },
        coordinatorExtPubKeyCurrentDepth: {
          type: "number",
          name: "BIP32 xpub current depth",
          description: "Depth to start new public keys be generation from",
          nullable: false,
          integral: true,
          range: "[1,*)",
          default: 1,
        },
        coordinationFeeRate: {
          type: "number",
          name: "Fee rate",
          description: "Fee rate, 0 is no fee, 0.1 is 10%, 0.003 is 0.3%",
          nullable: false,
          integral: false,
          range: "[0,.1]",
          default: 0.003,
        },
        plebsDontPayThreshold: {
          type: "number",
          name: "Plebs don't pay threshold",
          description:
            "Threshold for coins that don't incur the coordinator fee",
          nullable: false,
          integral: true,
          range: "[0,1000000000]",
          default: 1000000,
        },
        standardInputRegistrationTimeout: {
          type: "string",
          name: "Input registration timeout",
          description: "Registration duration for each round",
          nullable: false,
          default: "0d 1h 0m 0s",
          pattern: "^[0-9]{1,2}d [0-9]{1,2}h [0-9]{1,2}m [0-9]{1,2}s$",
          "pattern-description": "A duration in the format ##d ##h ##m ##s",
        },
        maxInputCountByRound: {
          type: "number",
          name: "Maximum inputs per round",
          description: "The maximum number of inputs per coinjoin round",
          nullable: false,
          integral: true,
          range: "[1, *)",
          default: 100,
        },
        minInputCountByRoundMultiplier: {
          type: "number",
          name: "Minimum inputs per round multiplier",
          description:
            "The minimum number of inputs required in a coinjoin round, as a multipler of 'Maximum inputs per round'",
          nullable: false,
          integral: false,
          range: "[0, 1]",
          default: 0.5,
        },
        minInputCountByBlameRoundMultiplier: {
          type: "number",
          name: "Minimum inputs multiplier for blame rounds",
          description:
            "The minimum number of inputs required in a blame round, as a multipler of 'Maximum inputs per round'",
          nullable: false,
          integral: false,
          range: "[0, 1]",
          default: 0.4,
        },
      },
    },
  } as const,
);

export type Config = typeof setConfigMatcher._TYPE;

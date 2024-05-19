import { compat, types as T } from "../deps.ts";
import { Config, setConfigMatcher } from "./getConfig.ts";

export const setConfig: T.ExpectedExports.setConfig = async (
  effects: T.Effects,
  input: T.Config,
) => {
  const config: Config = setConfigMatcher.unsafeCast(input);
  if (config.enablecoordinator && !config.coordinator.coordinatorExtPubKey) {
    return {
      error:
        "'Coordinator BIP32 xpub' is required when enabling the coordinator.",
    };
  }

  return await compat.setConfig(effects, config);
};

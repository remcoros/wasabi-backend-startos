import { types as T, healthUtil } from "../deps.ts";

export const health: T.ExpectedExports.health = {
  "web-api": healthUtil.checkWebUrl("http://wasabi-backend.embassy:80")
}

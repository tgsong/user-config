version = '0.21.2'

--------------------------------------------------------------------------------
-- key bindings
xplr.config.general.global_key_bindings = {
  on_key = {
    ["e"] = {
      help = "open in editor",
      messages = {
        {
          BashExec0 = [===[
            ${EDITOR:-vi} "${XPLR_FOCUS_PATH:?}"
          ]===],
        },
        "PopMode",
      },
    }
  }
}

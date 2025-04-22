# 🚗 OwlGaming Addon Vehicle Model Integration

This project modifies the **OwlGaming** gamemode for **Multi Theft Auto: San Andreas (MTA:SA)** to support **addon vehicle models** without replacing any of the original GTA:SA vehicles.

## ✨ Features

- ✅ Addon vehicle support without replacing existing vehicles  
- ✅ Fully integrated into the OwlGaming gamemode  
- ✅ Powered by [**NewModels**](https://github.com/Fernando-A-Rocha/mta-add-models) by [Fernando A. Rocha](https://github.com/Fernando-A-Rocha)  
- ✅ Clean and conflict-free vehicle expansion for RP environments

## 📦 Installation

> ⚠️ **This addon assumes you already have a working OwlGaming server setup.**  
> I do **NOT provide support** for setting up OwlGaming itself.

1. Make sure your OwlGaming server is running correctly.
2. Go to your server’s `resources/` directory.
3. **Delete** the contents of the `[vehicle]` folder completely.
4. Copy the contents of this repository into the `[vehicle]` folder.

5. Open your `mtaserver.conf` file and make sure the resources start in the following order:

   ```xml
   <resource src="newmodels_azul" startup="1" />
   <resource src="vehicle" startup="1" />
   <resource src="vehicleplate" startup="1" />
   <resource src="vehicle-interiors" startup="1" />
   <resource src="vehicle_fuel" startup="1" />
   <resource src="vehicle_manager" startup="1" />
   <resource src="vehicle_load" startup="1" />
   <resource src="carshop-system" startup="1" />
   <resource src="carradio" startup="1" />
   ```

6. Restart your MTA server to apply the changes.

Your server is now ready to use addon vehicle models with no replacements required.

## 📘 How to add models

To learn how to correctly add your own models, refer to the official **NewModels documentation**:  
👉 [https://github.com/Fernando-A-Rocha/mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)

> ℹ️ **Important:**  
> All model IDs used for vehicles **must be negative**, such as `-1`, `-2`, `-3`, etc.  
> This ensures compatibility with the NewModels system and avoids conflicts with default GTA IDs.

## ⚠️ Compatibility Note

This addon requires **NewModels version 5.2.0 or higher**.  
Version **5.2.0 is already included in this project**, so no need to download it separately.

If you're using an **older version**, the integration **may not work properly**.

> 🆕 If a newer version of NewModels is available, it **might not be fully compatible** with this addon.  
> You're welcome to **try it**, but if issues occur, we recommend sticking with version **5.2.0**.  
> You can find the latest releases on the official NewModels GitHub:  
> 👉 [https://github.com/Fernando-A-Rocha/mta-add-models](https://github.com/Fernando-A-Rocha/mta-add-models)  
>  
> 🔄 If a new version is released and changes are needed, I will update this project accordingly.

## ⚠️ Warning

This project may not be 100% functional in all cases.  
I cannot guarantee that it won't cause issues or break something on your server.  
It is recommended to use this only if you are familiar with **Lua** scripting and understand how to troubleshoot and fix potential problems.

## 🔧 Powered By

This project uses [**NewModels**](https://github.com/Fernando-A-Rocha/mta-add-models) to register and load custom vehicle models with unique IDs dynamically – without replacing any GTA:SA defaults.

## 🧠 Notes

- Designed specifically for the OwlGaming framework  
- Addon models use **new negative IDs**, allowing unlimited vehicle expansion  
- Ideal for RP servers looking to expand their garage without issues

## 🙌 Credits

- Thanks to [Fernando A. Rocha](https://github.com/Fernando-A-Rocha) for the incredible [NewModels](https://github.com/Fernando-A-Rocha/mta-add-models) system  
- OwlGaming community for the original gamemode

## ☕ Support Me

If you find this useful and want to support my work, you can do so here:  
👉 [https://paypal.me/brumicekcze](https://paypal.me/brumicekcze)

---

**Bring in new vehicles. No limits, no replacements. Just freedom.**

# nopCommerce Development Setup

## Development Tools

This repository includes development tools to help you work with nopCommerce plugins. The main tool is the `clone` script which helps you clone and set up plugins in the correct location.

### Using the Clone Script

#### Inside Dev Container (VS Code)
When using VS Code with Dev Containers, the `clone` script is automatically available in your PATH. You can use it from any directory within the nopCommerce project:

```bash
clone PLUGIN_NAME
```

#### On Host Machine
To use the clone script on your host machine, you have two options:

1. **Temporary Usage**: Source the setup script in your current terminal:
   ```bash
   source setup-dev.sh
   ```

2. **Permanent Setup**: Add the following line to your ~/.bashrc or ~/.zshrc:
   ```bash
   source /path/to/nopCommerce/setup-dev.sh
   ```
   Replace `/path/to/nopCommerce` with the actual path to your nopCommerce directory.

After setting up, you can use the `clone` command from any directory within the nopCommerce project:
```bash
clone PLUGIN_NAME
```

This will:
1. Clone the plugin repository into the correct location under src/Plugins
2. Update .gitignore to ignore the plugin directory
3. Commit the .gitignore changes

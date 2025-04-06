<div align="center">
  <h1>🔗 Links: A Browser Homepage
  </h1>
  <img src="./assets/links_thumbnail.png">
</div>

This project aims to improve the experience when starting a browser to display a visually pleasing interface featuring all your favorite bookmarks, which can also be used as a platform to share your bookmarks to other people.

To make maintenance easier, this uses a little bit of JavaScript for dynamic changes in the webpage to change buttons and links, and also uses JSON files to store all the data. While there is no interface to add links interactively, there is a shell script that uses `jq` to add new data to those JSON files.

All icons loaded in the webpage are sourced from DuckDuckGo's Favicon Extractor to increase reliability and better favicon quality. None are stored in this project.

## How it works

Currently, many parts of this project is hardcoded, specially the index.html, such as the webpage metadata, sidebar contents, footer content, and sourced JSON files.

Initially the webpage is constructed appending the top buttons to it, which can be added by editing the html files in the `pages/` directory, or adding a new one in the same format. After that, there is a hardcoded button which is automatically switched to display some first content. All the links are stored in the `data/` directory. Each button is related to a specific JSON file, which is named exactly as its class. So, each data that are not in the right file will not be displayed.

### JSON Structure

```json
  {
    "id": "software",
    "sub_id": "Linux",
    "title": "Arch Linux",
    "url": "https://archlinux.org/",
    "icon": "https://external-content.duckduckgo.com/ip3/archlinux.org.ico"
  },
```

- The id has the same name as the file, and its class. A mismatched name will not display the link.
- The sub_id corresponds to the Section Name, in this case a new row will be created and named as "Linux"
- The title is the link name, which will be displayed in the "Linux" row
- The icon can be automatically gathered using the `add-link.sh`

## How to use

You can locally run your webpage by running the following command in the root directory of this project.

```bash
python -m http.server 8080
```

Or, perhaps, you want to host it. If so, you can fork it and make the necessary changes, and then use Github Pages to host it as this [demo](https://janpstrunn.github.io/links/).

## Future Plans

For now, new features are not planned.

- [x] Optimize the overall code
- [ ] Remove hardcoded content
- [ ] Create a template

## License

This repository is licensed under the MIT License, a very permissive license that allows you to use, modify, copy, distribute and more.

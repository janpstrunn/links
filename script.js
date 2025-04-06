// Mapping sections to JSON file paths
console.log(jsonMappings);

// Function to load JSON and update content
function switchSection(section) {
  const jsonFile = jsonMappings[section];
  if (!jsonFile) {
    console.error("No JSON file mapped for section:", section);
    return;
  }

  let container = document.getElementById("content-container");
  container.innerHTML = "";

  fetch(jsonFile)
    .then((response) => response.json())
    .then((links) => {
      let groupedLinks = {};

      links.forEach((link) => {
        if (!groupedLinks[link.id]) groupedLinks[link.id] = {};
        if (!groupedLinks[link.id][link.sub_id])
          groupedLinks[link.id][link.sub_id] = [];
        groupedLinks[link.id][link.sub_id].push(link);
      });

      Object.keys(groupedLinks)
        .sort()
        .forEach((id) => {
          let sectionDiv = document.createElement("div");
          sectionDiv.className = "section hidden";
          sectionDiv.id = id;

          let sectionTitle = document.createElement("h2");
          sectionTitle.textContent = `${id.toUpperCase()}`;
          sectionTitle.className = `${id}`;
          sectionDiv.appendChild(sectionTitle);

          let columnsContainer = document.createElement("div");
          columnsContainer.className = "columns-container";

          Object.keys(groupedLinks[id])
            .sort()
            .forEach((sub_id) => {
              let columnDiv = document.createElement("div");
              columnDiv.className = "column";

              let subIdTitle = document.createElement("h3");
              subIdTitle.className = `sub_id_title ${id}`;
              subIdTitle.textContent = `${sub_id}`;
              columnDiv.appendChild(subIdTitle);

              groupedLinks[id][sub_id]
                .sort((a, b) => a.title.localeCompare(b.title))
                .forEach((link) => {
                  let a = document.createElement("a");
                  a.href = link.url;
                  a.className = "card";
                  a.innerHTML = `<img src="${link.icon}" width="32"><p>${link.title}</p>`;
                  columnDiv.appendChild(a);
                });

              columnsContainer.appendChild(columnDiv);
            });

          sectionDiv.appendChild(columnsContainer);
          container.appendChild(sectionDiv);
        });

      const allSections = document.querySelectorAll(".section");
      allSections.forEach((section) => section.classList.add("hidden"));

      const targetSection = document.getElementById(section);
      if (targetSection) {
        targetSection.classList.remove("hidden");
      }

      document
        .querySelectorAll(".section-selector button")
        .forEach((button) => {
          button.classList.remove("active");
        });
      document
        .querySelector(`button[onclick="switchSection('${section}')"]`)
        .classList.add("active");
    })
    .catch((error) => {
      console.error("Error loading JSON file:", error);
    });
}

// Toggle Sidebar
function toggleSidebar() {
  const sidebar = document.getElementById("sidebar");
  const sidebarContent = document.getElementById("sidebar-content");
  const contentSource = document.getElementById("mainpage-content");

  if (sidebar.classList.contains("actived")) {
    sidebar.classList.remove("actived");
  } else {
    sidebarContent.innerHTML = contentSource.innerHTML;
    sidebar.classList.add("actived");

    document.addEventListener("click", function closeSidebar(event) {
      if (
        !sidebar.contains(event.target) &&
        event.target.className !== "toggle-btn"
      ) {
        sidebar.classList.remove("actived");
        document.removeEventListener("click", closeSidebar);
      }
    });
  }
}

// Switch Page
function loadPage() {
  const params = new URLSearchParams(window.location.search);
  const page = params.get("page") || "home";

  fetch(`pages/${page}.html`)
    .then((response) => {
      if (!response.ok) throw new Error("Page not found");
      return response.text();
    })
    .then((html) => {
      document.getElementById("dynamic-content").innerHTML = html;
    })
    .catch(() => {
      document.getElementById("dynamic-content").innerHTML =
        "<p>Page not found.</p>";
    });

  switchSection(page);
}

function changePage(page) {
  history.pushState(null, "", `?page=${page}`);
  loadPage();
  switchSection(page);
}

window.addEventListener("popstate", loadPage);
loadPage();

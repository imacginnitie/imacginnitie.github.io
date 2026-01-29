// get the ninja-keys element
const ninja = document.querySelector('ninja-keys');

// add the home and posts menu items
ninja.data = [{
    id: "nav-about",
    title: "about",
    section: "Navigation",
    handler: () => {
      window.location.href = "/";
    },
  },{id: "nav-projects",
          title: "projects",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/projects/";
          },
        },{id: "nav-photography",
          title: "photography",
          description: "",
          section: "Navigation",
          handler: () => {
            window.location.href = "/photography/";
          },
        },{id: "nav-cv",
          title: "cv",
          description: "Last updated 12/11/2025",
          section: "Navigation",
          handler: () => {
            window.location.href = "/cv/";
          },
        },{id: "news-i-was-awarded-the-nsf-csgrad4us-fellowship-funding-3-years-of-a-phd",
          title: 'I was awarded the NSF CSGrad4US fellowship, funding 3 years of a PhD!...',
          description: "",
          section: "News",},{id: "news-i-attended-the-athena-research-retreat-in-hostačov-czechia-for-a-week-of-amazing-talks-workshops-and-events-on-ai-alignment",
          title: 'I attended the Athena research retreat in Hostačov, Czechia, for a week of...',
          description: "",
          section: "News",},{id: "projects-model-organism-for-encoded-chain-of-thought",
          title: 'model organism for encoded chain of thought',
          description: "Athena AI Alignment Mentorship Program 2025",
          section: "Projects",handler: () => {
              window.location.href = "/projects/athena/";
            },},{id: "projects-building-an-intuitive-image-complexity-metric",
          title: 'building an intuitive image complexity metric',
          description: "Harvey Mudd College REU 2022",
          section: "Projects",handler: () => {
              window.location.href = "/projects/image-complexity/";
            },},{id: "projects-colorizing-b-amp-w-film",
          title: 'colorizing b&amp;amp;w film',
          description: "Computational Photography II 2021",
          section: "Projects",handler: () => {
              window.location.href = "/projects/colorizing-bw-film/";
            },},{id: "projects-deepdreamify",
          title: 'deepdreamify',
          description: "Machine Learning for Artists 2023",
          section: "Projects",handler: () => {
              window.location.href = "/projects/deepdreamify/";
            },},{id: "projects-peering-through-the-keyhole",
          title: 'peering through the keyhole',
          description: "Claremont, CA, 2022 // Fujifilm X-T4",
          section: "Projects",handler: () => {
              window.location.href = "/photography/peering-through-the-keyhole/";
            },},{id: "projects-fallingwater",
          title: 'fallingwater',
          description: "Frank Lloyd Wright&#39;s Fallingwater, PA, 2022 // Fujifilm X-T4",
          section: "Projects",handler: () => {
              window.location.href = "/photography/fallingwater/";
            },},{id: "projects-brutalism-gender-mudd",
          title: 'brutalism + gender @ mudd',
          description: "Claremont, CA, 2022 // Fujifilm X-T4",
          section: "Projects",handler: () => {
              window.location.href = "/photography/brutalism-gender-at-mudd/";
            },},{id: "projects-goodreads-wrapped",
          title: 'goodreads wrapped',
          description: "2024 &amp; 2025",
          section: "Projects",handler: () => {
              window.location.href = "/projects/goodreads-wrapped/";
            },},{
        id: 'social-cv',
        title: 'CV',
        section: 'Socials',
        handler: () => {
          window.open("/assets/pdf/Isabel_MacGinnitie_CV.pdf", "_blank");
        },
      },{
        id: 'social-email',
        title: 'email',
        section: 'Socials',
        handler: () => {
          window.open("mailto:%69%73%61%62%65%6C.%6D%61%63%67%69%6E%6E%69%74%69%65@%67%6D%61%69%6C.%63%6F%6D", "_blank");
        },
      },{
        id: 'social-github',
        title: 'GitHub',
        section: 'Socials',
        handler: () => {
          window.open("https://github.com/imacginnitie", "_blank");
        },
      },{
        id: 'social-linkedin',
        title: 'LinkedIn',
        section: 'Socials',
        handler: () => {
          window.open("https://www.linkedin.com/in/isabel-macginnitie", "_blank");
        },
      },{
        id: 'social-x',
        title: 'X',
        section: 'Socials',
        handler: () => {
          window.open("https://twitter.com/isabelfyi", "_blank");
        },
      },{
      id: 'light-theme',
      title: 'Change theme to light',
      description: 'Change the theme of the site to Light',
      section: 'Theme',
      handler: () => {
        setThemeSetting("light");
      },
    },
    {
      id: 'dark-theme',
      title: 'Change theme to dark',
      description: 'Change the theme of the site to Dark',
      section: 'Theme',
      handler: () => {
        setThemeSetting("dark");
      },
    },
    {
      id: 'system-theme',
      title: 'Use system default theme',
      description: 'Change the theme of the site to System Default',
      section: 'Theme',
      handler: () => {
        setThemeSetting("system");
      },
    },];

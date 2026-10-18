import '../domain/entities/portfolio.dart';

const portfolioContent = Portfolio(
  name: 'Elivince M. Timbas',
  handle: 'E. TIMBAS',
  role: 'Flutter Developer',
  bio:
      'I build thoughtful mobile experiences with Flutter. From shipped '
      'healthcare apps to Go backends, I turn complex requirements into clear, '
      'reliable products with BLoC and Clean Architecture.',
  location: 'Quezon City, Philippines',
  email: 'elivince.timbas11@gmail.com',
  linkedin: 'https://www.linkedin.com/in/elivince-timbas-72a25936a',
  cvPath: 'resume.pdf',
  availability: 'Open to opportunities',
  about: [
    'I’m a Flutter developer based in Quezon City, Philippines, with experience '
        'building and shipping cross-platform healthcare applications. My work '
        'spans mobile interfaces, real-time telemedicine, subscriptions, and '
        'backend services.',
    'I work with BLoC and Clean Architecture to keep features understandable '
        'and maintainable, and build REST APIs with Go, Gin, and GORM. I also '
        'develop web experiences with React, Next.js, and Supabase.',
    'I graduated Cum Laude from Bicol University in 2024 with a Bachelor of '
        'Science in Information Technology. I enjoy building useful software '
        'and improving the details that make it feel fast and dependable.',
  ],
  stats: [
    PortfolioStat(value: '02', label: 'Healthcare apps shipped'),
    PortfolioStat(value: '20%', label: 'Response & rendering gain'),
    PortfolioStat(value: '2024', label: 'BSIT · Cum Laude'),
  ],
  skills: [
    SkillGroup(
      name: 'Mobile & Frontend',
      skills: ['Dart', 'Flutter', 'BLoC', 'Dio', 'Sqflite', 'React', 'Next.js'],
    ),
    SkillGroup(
      name: 'Backend',
      skills: ['Golang', 'Gin', 'GORM', 'JWT', 'REST API'],
    ),
    SkillGroup(
      name: 'Databases & BaaS',
      skills: ['MySQL', 'PostgreSQL', 'Supabase', 'Firebase'],
    ),
    SkillGroup(
      name: 'Tools & Workflows',
      skills: ['Git', 'GitHub', 'Application Deployment', 'Trello', 'Slack'],
    ),
  ],
  experience: [
    Experience(
      role: 'Flutter Developer',
      company: 'Lifesaver Medicords',
      period: 'Mar 2025 — Present',
      summary:
          'Developed and deployed Lifesaver for Family and Lifesaver for '
          'Doctors to the App Store and Google Play. Built telemedicine '
          'features with WebRTC and WebSockets, integrated in-app subscriptions, '
          'and improved response and rendering performance by 20%. Contributed '
          'to Go backend services using Gin and GORM.',
      technologies: ['Flutter', 'BLoC', 'Go', 'WebRTC', 'In-app purchases'],
    ),
    Experience(
      role: 'Freelance Web Developer',
      company: 'SRRV Website',
      period: 'Jun — Sep 2026',
      summary:
          'Developed an SRRV website with React, Next.js, and Supabase. '
          'Worked on PostgreSQL database normalization, row-level security, '
          'triggers, and stored procedures.',
      technologies: ['React', 'Next.js', 'Supabase', 'PostgreSQL'],
    ),
  ],
  projects: [
    Project(
      title: 'Lifesaver for Family',
      category: 'HEALTHCARE · MOBILE APP',
      description:
          'A cross-platform healthcare application for families, shipped to '
          'the App Store and Google Play. Built with Flutter and BLoC, with '
          'telemedicine and in-app subscription features.',
      technologies: ['Flutter', 'BLoC', 'WebRTC'],
      kind: ProjectKind.family,
    ),
    Project(
      title: 'Lifesaver for Doctors',
      category: 'HEALTHCARE · MOBILE APP',
      description:
          'The companion healthcare application for doctors, shipped to the '
          'App Store and Google Play. Supports real-time telemedicine with '
          'WebRTC and WebSockets, backed by Go services.',
      technologies: ['Flutter', 'Go', 'WebSockets'],
      kind: ProjectKind.doctors,
    ),
    Project(
      title: 'SRRV',
      category: 'FREELANCE · WEB DEVELOPMENT',
      description:
          'A React and Next.js website backed by Supabase and PostgreSQL. '
          'The work includes database normalization, row-level security, '
          'triggers, and stored procedures.',
      technologies: ['Next.js', 'Supabase', 'PostgreSQL'],
      kind: ProjectKind.web,
    ),
    Project(
      title: 'Food-Tripid',
      category: 'MOBILE APP · 2023',
      description:
          'A Flutter food-sharing application with Firebase authentication, '
          'user profiles, posts, following, and likes. Includes search and '
          'filtering to help people explore shared food experiences.',
      technologies: ['Flutter', 'Dart', 'Firebase'],
      kind: ProjectKind.food,
    ),
  ],
  education: Education(
    school: 'Bicol University — Main Campus',
    degree: 'BS Information Technology',
    year: '2024',
    honors: 'Cum Laude · Dean’s Lister 2021–2024 · GWA 1.606',
  ),
);

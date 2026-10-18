class Portfolio {
  const Portfolio({
    required this.name,
    required this.handle,
    required this.role,
    required this.bio,
    required this.location,
    required this.email,
    required this.linkedin,
    required this.cvPath,
    required this.availability,
    required this.about,
    required this.stats,
    required this.skills,
    required this.experience,
    required this.projects,
    required this.education,
  });

  final String name;
  final String handle;
  final String role;
  final String bio;
  final String location;
  final String email;
  final String linkedin;
  final String cvPath;
  final String availability;
  final List<String> about;
  final List<PortfolioStat> stats;
  final List<SkillGroup> skills;
  final List<Experience> experience;
  final List<Project> projects;
  final Education education;
}

class PortfolioStat {
  const PortfolioStat({required this.value, required this.label});

  final String value;
  final String label;
}

class SkillGroup {
  const SkillGroup({required this.name, required this.skills});

  final String name;
  final List<String> skills;
}

class Experience {
  const Experience({
    required this.role,
    required this.company,
    required this.period,
    required this.summary,
    required this.technologies,
  });

  final String role;
  final String company;
  final String period;
  final String summary;
  final List<String> technologies;
}

enum ProjectKind { family, doctors, web, food }

class Project {
  const Project({
    required this.title,
    required this.category,
    required this.description,
    required this.technologies,
    required this.kind,
  });

  final String title;
  final String category;
  final String description;
  final List<String> technologies;
  final ProjectKind kind;
}

class Education {
  const Education({
    required this.school,
    required this.degree,
    required this.year,
    required this.honors,
  });

  final String school;
  final String degree;
  final String year;
  final String honors;
}

import '../domain/course_category.dart';
import '../domain/course_level.dart';
import 'mock_models.dart';

/// Datos de ejemplo de la maqueta. Temporal: cada etapa los sustituye.
abstract final class MockData {
  /// Usuario mock activo en la sesión.
  static const MockUser user = MockUser(
    name: 'Alex Rivera',
    discordTag: 'alexdev',
    weeklyHours: 10,
    streakDays: 5,
  );

  /// Catálogo con 12 cursos reales que cubren las 6 categorías del dataset.
  static const List<MockCourse> catalog = <MockCourse>[
    MockCourse(
      slug: 'git-github-control-versiones-desde-cero',
      name: 'GIT+GitHub: Control de versiones desde Cero',
      hours: 11.5,
      lessons: 132,
      instructor: 'Fernando Herrera',
      category: CourseCategory.bases,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    MockCourse(
      slug: 'typescript-guia-completa',
      name: 'TypeScript: Guía Completa - Fernando Herrera',
      hours: 8.5,
      lessons: 115,
      instructor: 'Fernando Herrera',
      category: CourseCategory.bases,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    MockCourse(
      slug: 'react-de-cero',
      name: 'React: de cero a experto - Edición 2025',
      hours: 46.0,
      lessons: 452,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    MockCourse(
      slug: 'nextjs',
      name: 'Next.js: El framework de React - Fernando Herrera',
      hours: 39.0,
      lessons: 423,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'zustand-gestor-de-estado-para-react',
      name: 'Zustand: Gestor de estado para React',
      hours: 6.0,
      lessons: 78,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'nest',
      name: 'Nest: Desarrollo backend escalable Node - Fernando Herrera',
      hours: 24.5,
      lessons: 228,
      instructor: 'Fernando Herrera',
      category: CourseCategory.backend,
      level: CourseLevel.required,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'docker-guia-practica',
      name: 'Docker - Guía práctica de uso para desarrolladores',
      hours: 14.0,
      lessons: 134,
      instructor: 'Fernando Herrera',
      category: CourseCategory.backend,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'dart-cero-hasta-detalles',
      name: 'Dart: De cero hasta los detalles - Fernando Herrera',
      hours: 10.0,
      lessons: 128,
      instructor: 'Fernando Herrera',
      category: CourseCategory.mobile,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    MockCourse(
      slug: 'flutter-movil-cero-a-experto',
      name: 'Flutter - Móvil: De cero a experto - Fernando Herrera',
      hours: 50.0,
      lessons: 463,
      instructor: 'Fernando Herrera',
      category: CourseCategory.mobile,
      level: CourseLevel.required,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'flutter-Intermedio',
      name: 'Flutter Intermedio: Diseños profesionales y animaciones',
      hours: 15.0,
      lessons: 188,
      instructor: 'Fernando Herrera',
      category: CourseCategory.mobile,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'Flutter-Gemini',
      name: 'Flutter + Gemini: Aplicaciones con inteligencia artificial',
      hours: 8.5,
      lessons: 105,
      instructor: 'Fernando Herrera',
      category: CourseCategory.aiAgents,
      level: CourseLevel.optional,
      isCompleted: false,
    ),
    MockCourse(
      slug: 'netfullstack',
      name: '.NET Fullstack: Arquitectura limpia al frontend y Blazor',
      hours: 14.0,
      lessons: 183,
      instructor: 'Teddy Paz',
      category: CourseCategory.fullstack,
      level: CourseLevel.optional,
      isCompleted: false,
    ),
  ];

  /// 3 rutas mock: 'frontend-react', 'backend-nest', 'movil-flutter'.
  static const List<MockRoute> routes = <MockRoute>[
    MockRoute(
      id: 'frontend-react',
      title: 'Frontend Profesional con React y Next.js',
      description: 'Domina el ecosistema de React desde las bases de TypeScript hasta el desarrollo fullstack con Next.js y gestión de estado con Zustand.',
      courses: <MockCourse>[
        MockCourse(
          slug: 'typescript-guia-completa',
          name: 'TypeScript: Guía Completa - Fernando Herrera',
          hours: 8.5,
          lessons: 115,
          instructor: 'Fernando Herrera',
          category: CourseCategory.bases,
          level: CourseLevel.required,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'react-de-cero',
          name: 'React: de cero a experto - Edición 2025',
          hours: 46.0,
          lessons: 452,
          instructor: 'Fernando Herrera',
          category: CourseCategory.frontend,
          level: CourseLevel.required,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'zustand-gestor-de-estado-para-react',
          name: 'Zustand: Gestor de estado para React',
          hours: 6.0,
          lessons: 78,
          instructor: 'Fernando Herrera',
          category: CourseCategory.frontend,
          level: CourseLevel.recommended,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'nextjs',
          name: 'Next.js: El framework de React - Fernando Herrera',
          hours: 39.0,
          lessons: 423,
          instructor: 'Fernando Herrera',
          category: CourseCategory.frontend,
          level: CourseLevel.recommended,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'git-github-control-versiones-desde-cero',
          name: 'GIT+GitHub: Control de versiones desde Cero',
          hours: 11.5,
          lessons: 132,
          instructor: 'Fernando Herrera',
          category: CourseCategory.bases,
          level: CourseLevel.optional,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'netfullstack',
          name: '.NET Fullstack: Arquitectura limpia al frontend y Blazor',
          hours: 14.0,
          lessons: 183,
          instructor: 'Teddy Paz',
          category: CourseCategory.fullstack,
          level: CourseLevel.optional,
          isCompleted: false,
        ),
      ],
    ),
    MockRoute(
      id: 'backend-nest',
      title: 'Backend Escalable con NestJS y Docker',
      description: 'Aprende a construir APIs modulares, escalables y seguras con TypeScript, NestJS y despliegue en contenedores Docker.',
      courses: <MockCourse>[
        MockCourse(
          slug: 'typescript-guia-completa',
          name: 'TypeScript: Guía Completa - Fernando Herrera',
          hours: 8.5,
          lessons: 115,
          instructor: 'Fernando Herrera',
          category: CourseCategory.bases,
          level: CourseLevel.required,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'nest',
          name: 'Nest: Desarrollo backend escalable Node - Fernando Herrera',
          hours: 24.5,
          lessons: 228,
          instructor: 'Fernando Herrera',
          category: CourseCategory.backend,
          level: CourseLevel.required,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'docker-guia-practica',
          name: 'Docker - Guía práctica de uso para desarrolladores',
          hours: 14.0,
          lessons: 134,
          instructor: 'Fernando Herrera',
          category: CourseCategory.backend,
          level: CourseLevel.recommended,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'git-github-control-versiones-desde-cero',
          name: 'GIT+GitHub: Control de versiones desde Cero',
          hours: 11.5,
          lessons: 132,
          instructor: 'Fernando Herrera',
          category: CourseCategory.bases,
          level: CourseLevel.recommended,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'netfullstack',
          name: '.NET Fullstack: Arquitectura limpia al frontend y Blazor',
          hours: 14.0,
          lessons: 183,
          instructor: 'Teddy Paz',
          category: CourseCategory.fullstack,
          level: CourseLevel.optional,
          isCompleted: false,
        ),
      ],
    ),
    MockRoute(
      id: 'movil-flutter',
      title: 'Desarrollo Móvil Multiplataforma con Flutter',
      description: 'Crea aplicaciones hermosas y fluidas para iOS y Android con Dart, Flutter, animaciones avanzadas e integración de IA con Gemini.',
      courses: <MockCourse>[
        MockCourse(
          slug: 'dart-cero-hasta-detalles',
          name: 'Dart: De cero hasta los detalles - Fernando Herrera',
          hours: 10.0,
          lessons: 128,
          instructor: 'Fernando Herrera',
          category: CourseCategory.mobile,
          level: CourseLevel.required,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'flutter-movil-cero-a-experto',
          name: 'Flutter - Móvil: De cero a experto - Fernando Herrera',
          hours: 50.0,
          lessons: 463,
          instructor: 'Fernando Herrera',
          category: CourseCategory.mobile,
          level: CourseLevel.required,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'flutter-Intermedio',
          name: 'Flutter Intermedio: Diseños profesionales y animaciones',
          hours: 15.0,
          lessons: 188,
          instructor: 'Fernando Herrera',
          category: CourseCategory.mobile,
          level: CourseLevel.recommended,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'git-github-control-versiones-desde-cero',
          name: 'GIT+GitHub: Control de versiones desde Cero',
          hours: 11.5,
          lessons: 132,
          instructor: 'Fernando Herrera',
          category: CourseCategory.bases,
          level: CourseLevel.recommended,
          isCompleted: true,
        ),
        MockCourse(
          slug: 'Flutter-Gemini',
          name: 'Flutter + Gemini: Aplicaciones con inteligencia artificial',
          hours: 8.5,
          lessons: 105,
          instructor: 'Fernando Herrera',
          category: CourseCategory.aiAgents,
          level: CourseLevel.optional,
          isCompleted: false,
        ),
        MockCourse(
          slug: 'docker-guia-practica',
          name: 'Docker - Guía práctica de uso para desarrolladores',
          hours: 14.0,
          lessons: 134,
          instructor: 'Fernando Herrera',
          category: CourseCategory.backend,
          level: CourseLevel.optional,
          isCompleted: false,
        ),
      ],
    ),
  ];

  /// Identificador de la ruta activa en el Home.
  static const String activeRouteId = 'frontend-react';

  /// Identificador de la ruta generada por el cuestionario.
  static const String generatedRouteId = 'frontend-react';

  /// Preguntas diagnósticas del cuestionario.
  static const List<MockQuizQuestion> quizQuestions = <MockQuizQuestion>[
    MockQuizQuestion(
      prompt: '¿Qué área del desarrollo de software te interesa dominar?',
      options: <String>[
        'Frontend con React y Next.js',
        'Backend escalable con Node y NestJS',
        'Desarrollo móvil con Dart y Flutter',
        'Inteligencia Artificial y Agentes',
      ],
    ),
    MockQuizQuestion(
      prompt: '¿Cuál es tu nivel actual de experiencia en programación?',
      options: <String>[
        'Principiante / Comenzando desde cero',
        'Intermedio con proyectos personales construidos',
        'Avanzado buscando especialización en producción',
      ],
    ),
    MockQuizQuestion(
      prompt:
          '¿Cuántas horas semanales puedes dedicar a tu ruta de aprendizaje?',
      options: <String>[
        '5 horas por semana (Ritmo suave)',
        '10 horas por semana (Recomendado)',
        '20 horas por semana (Intensivo)',
        'Más de 30 horas por semana (Inmersión total)',
      ],
    ),
  ];

  /// Devuelve la ruta que coincide con [id], o `null` si no existe.
  static MockRoute? routeById(String id) {
    for (final MockRoute route in routes) {
      if (route.id == id) return route;
    }
    return null;
  }
}

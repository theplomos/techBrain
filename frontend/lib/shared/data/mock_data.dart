import '../models/course.dart';
import '../models/roadmap.dart';
import '../models/user_profile.dart';

/// Repositorio de datos mock offline basados en el catálogo oficial de DevTalles.
/// Permite probar la aplicación sin conexión al backend.
abstract final class MockData {
  static const UserProfile demoUser = UserProfile(
    id: 'usr-devtalles-13',
    name: 'Alex Rivera',
    discordTag: 'alex_code#1337',
    avatarUrl: 'https://avatars.githubusercontent.com/u/10001?v=4',
    streakDays: 5,
    weeklyHours: 10,
    completedCoursesCount: 4,
    totalHoursLearned: 34,
    quizAccuracyPercentage: 88,
  );

  static const List<Course> catalogCourses = <Course>[
    Course(
      slug: 'react-de-cero-a-experto',
      name: 'React: De cero a experto (Hooks y MERN)',
      description:
          'Aprende React desde las bases hasta la creación de apps profesionales con Hooks, Context, Redux Toolkit y Vite.',
      hours: 40.5,
      lessons: 320,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    Course(
      slug: 'tanstack-query',
      name: 'TanStack Query: Manejo de estado asíncrono',
      description:
          'Gestión de peticiones, caché automático, mutaciones y sincronización en segundo plano con React.',
      hours: 12.0,
      lessons: 95,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    Course(
      slug: 'zustand-gestor-de-estado-para-react',
      name: 'Zustand: Gestor de estado para React',
      description:
          'Una solución simple, pequeña y escalable para el manejo de estado global sin boilerplate.',
      hours: 8.5,
      lessons: 64,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    Course(
      slug: 'nextjs',
      name: 'Next.js: El framework de React para producción',
      description:
          'Server Components, Server Actions, App Router, optimización de imágenes y despliegue profesional.',
      hours: 32.0,
      lessons: 240,
      instructor: 'Fernando Herrera',
      category: CourseCategory.frontend,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    Course(
      slug: 'nest-backend',
      name: 'NestJS: Creación de API y Microservicios modulares',
      description:
          'Construye APIs empresariales con TypeScript, TypeORM, PostgreSQL, autenticación JWT y Docker.',
      hours: 38.0,
      lessons: 285,
      instructor: 'Fernando Herrera',
      category: CourseCategory.backend,
      level: CourseLevel.required,
      isCompleted: false,
    ),
    Course(
      slug: 'dart-cero-hasta-detalles',
      name: 'Dart: De cero hasta los detalles',
      description:
          'Domina el lenguaje detrás de Flutter: programación orientada a objetos, Streams, Futures y genéricos.',
      hours: 15.0,
      lessons: 110,
      instructor: 'Fernando Herrera',
      category: CourseCategory.bases,
      level: CourseLevel.required,
      isCompleted: true,
    ),
    Course(
      slug: 'flutter-intermedio',
      name: 'Flutter: Diseños increíbles y widgets avanzados',
      description:
          'Animaciones implícitas y explícitas, Custom Painters, SliverAppBar y arquitecturas escalables.',
      hours: 28.0,
      lessons: 210,
      instructor: 'Fernando Herrera',
      category: CourseCategory.movil,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
    Course(
      slug: 'go-microservicios',
      name: 'Go (Golang): Microservicios y sistemas distribuidos',
      description:
          'Concurrencia con Goroutines, Canales, gRPC y arquitectura de alta concurrencia en Go.',
      hours: 25.0,
      lessons: 180,
      instructor: 'DevTalles Team',
      category: CourseCategory.backend,
      level: CourseLevel.optional,
      isCompleted: false,
    ),
    Course(
      slug: 'ia-agentes-mcp',
      name: 'Agentes de IA y Model Context Protocol (MCP)',
      description:
          'Conecta modelos LLM como Gemini y Claude a herramientas externas, bases de datos y orquestación con n8n.',
      hours: 18.0,
      lessons: 130,
      instructor: 'DevTalles Team',
      category: CourseCategory.ai,
      level: CourseLevel.recommended,
      isCompleted: false,
    ),
  ];

  static const List<Roadmap> initialRoadmaps = <Roadmap>[
    Roadmap(
      id: 'roadmap-react-frontend',
      title: 'Frontend Moderno con React y Next.js',
      description:
          'Domina el ecosistema React moderno: desde los fundamentos hasta arquitecturas SSR con Next.js y Zustand.',
      category: CourseCategory.frontend,
      progressPercentage: 0.68,
      totalCourses: 18,
      completedCourses: 12,
      estimatedWeeks: 3,
      isActive: true,
      courses: <Course>[
        Course(
          slug: 'react-de-cero-a-experto',
          name: 'React: De cero a experto',
          description: 'Fundamentos de React y Hooks.',
          hours: 40.5,
          lessons: 320,
          instructor: 'Fernando Herrera',
          category: CourseCategory.frontend,
          level: CourseLevel.required,
          isCompleted: true,
        ),
        Course(
          slug: 'tanstack-query',
          name: 'TanStack Query',
          description: 'Caché y sincronización de datos.',
          hours: 12.0,
          lessons: 95,
          instructor: 'Fernando Herrera',
          category: CourseCategory.frontend,
          level: CourseLevel.required,
          isCompleted: true,
        ),
        Course(
          slug: 'zustand-gestor-de-estado-para-react',
          name: 'Zustand: Gestor de estado',
          description: 'Estado global ligero.',
          hours: 8.5,
          lessons: 64,
          instructor: 'Fernando Herrera',
          category: CourseCategory.frontend,
          level: CourseLevel.recommended,
          isCompleted: false,
        ),
      ],
    ),
    Roadmap(
      id: 'roadmap-nestjs-backend',
      title: 'Backend Profesional con NestJS & Microservicios',
      description:
          'Arquitectura escalable en Node.js, patrones empresariales, TypeScript y Docker.',
      category: CourseCategory.backend,
      progressPercentage: 0.35,
      totalCourses: 14,
      completedCourses: 5,
      estimatedWeeks: 6,
      isActive: false,
      courses: <Course>[],
    ),
    Roadmap(
      id: 'roadmap-flutter-dart',
      title: 'Desarrollo Multiplataforma con Flutter & Dart',
      description:
          'Crea aplicaciones nativas para iOS, Android, Web y Desktop con un único código base.',
      category: CourseCategory.movil,
      progressPercentage: 0.50,
      totalCourses: 12,
      completedCourses: 6,
      estimatedWeeks: 4,
      isActive: false,
      courses: <Course>[],
    ),
    Roadmap(
      id: 'roadmap-ai-agents',
      title: 'Agentes de Inteligencia Artificial & MCP',
      description:
          'Construye agentes autónomos utilizando Gemini, Claude, herramientas MCP y flujos en n8n.',
      category: CourseCategory.ai,
      progressPercentage: 0.20,
      totalCourses: 8,
      completedCourses: 2,
      estimatedWeeks: 5,
      isActive: false,
      courses: <Course>[],
    ),
  ];
}

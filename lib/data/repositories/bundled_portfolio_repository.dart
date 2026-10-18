import '../../domain/entities/portfolio.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../portfolio_content.dart';

class BundledPortfolioRepository implements PortfolioRepository {
  const BundledPortfolioRepository();

  @override
  Portfolio getPortfolio() => portfolioContent;
}

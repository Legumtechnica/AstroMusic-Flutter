import 'package:flutter/material.dart';
import 'package:astro_music/config/size_config.dart';
import 'package:astro_music/provider/base_view.dart';
import 'package:astro_music/view/cosmic_dashboard_view_model.dart';
import 'package:astro_music/enum/view_state.dart';
import 'package:astro_music/models/raag.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CosmicDashboardScreen extends StatelessWidget {
  static const routeName = '/cosmic_dashboard';
  const CosmicDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<CosmicDashboardViewModel>(
      onModelReady: (model) => model.loadDashboard(),
      builder: (context, model, child) => Scaffold(
        body: Container(
          height: SizeConfig.height,
          width: SizeConfig.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F3460),
              ],
            ),
          ),
          child: SafeArea(
            child: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : model.errorMessage != null
                    ? _buildError(model)
                    : _buildDashboard(context, model),
          ),
        ),
      ),
    );
  }

  Widget _buildError(CosmicDashboardViewModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text(
            model.errorMessage ?? 'An error occurred',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, CosmicDashboardViewModel model) {
    return RefreshIndicator(
      onRefresh: () => model.loadDashboard(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(proportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(model),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildCosmicInfluenceCard(model),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildEnergyMeter(model),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildRecommendations(model),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildDailyPlaylist(model),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildQuickActions(model),
            SizedBox(height: proportionateScreenHeight(20)),
            _buildRecommendedRaags(model),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CosmicDashboardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cosmic Dashboard',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: proportionateScreenWidth(32),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: proportionateScreenHeight(8)),
        Text(
          'Your personalized astrological insights for today',
          style: TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: proportionateScreenWidth(14),
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildCosmicInfluenceCard(CosmicDashboardViewModel model) {
    if (model.todaysInfluence == null) return Container();

    return GlassmorphicContainer(
      width: double.infinity,
      height: proportionateScreenHeight(200),
      borderRadius: 20,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(proportionateScreenWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  model.getEnergyLevelEmoji(),
                  style: TextStyle(fontSize: proportionateScreenWidth(32)),
                ),
                SizedBox(width: proportionateScreenWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.getEnergyLevelText(),
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: proportionateScreenWidth(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Overall Score: ${model.todaysInfluence!.overallScore.toInt()}%',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: proportionateScreenWidth(12),
                          color: Color(0xFFE94560),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              model.todaysInfluence!.overallDescription,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: proportionateScreenWidth(14),
                color: Colors.white.withOpacity(0.9),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (model.todaysInfluence!.luckyRaag != null)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: proportionateScreenWidth(12),
                  vertical: proportionateScreenHeight(6),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE94560).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '✨ Lucky Raag: ${model.todaysInfluence!.luckyRaag}',
                  style: TextStyle(
                    fontFamily: 'SF Pro Text',
                    fontSize: proportionateScreenWidth(12),
                    color: Color(0xFFE94560),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyMeter(CosmicDashboardViewModel model) {
    if (model.todaysInfluence == null) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Energy Flow',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: proportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: proportionateScreenHeight(12)),
        GlassmorphicContainer(
          width: double.infinity,
          height: proportionateScreenHeight(80),
          borderRadius: 15,
          blur: 20,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: proportionateScreenWidth(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overall Energy',
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: proportionateScreenWidth(14),
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${model.todaysInfluence!.overallScore.toInt()}%',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: proportionateScreenWidth(14),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE94560),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: proportionateScreenHeight(8)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: model.todaysInfluence!.overallScore / 100,
                    minHeight: 12,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE94560)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations(CosmicDashboardViewModel model) {
    if (model.todaysInfluence == null ||
        model.todaysInfluence!.recommendations.isEmpty) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cosmic Recommendations',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: proportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: proportionateScreenHeight(12)),
        ...model.todaysInfluence!.recommendations.map((rec) => Padding(
              padding: EdgeInsets.only(bottom: proportionateScreenHeight(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✨', style: TextStyle(fontSize: proportionateScreenWidth(16))),
                  SizedBox(width: proportionateScreenWidth(8)),
                  Expanded(
                    child: Text(
                      rec,
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: proportionateScreenWidth(14),
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDailyPlaylist(CosmicDashboardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Cosmic Playlist',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: proportionateScreenWidth(18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () => model.regeneratePlaylist(),
              child: Icon(
                Icons.refresh,
                color: Color(0xFFE94560),
                size: proportionateScreenWidth(24),
              ),
            ),
          ],
        ),
        SizedBox(height: proportionateScreenHeight(12)),
        GlassmorphicContainer(
          width: double.infinity,
          height: proportionateScreenHeight(100),
          borderRadius: 15,
          blur: 20,
          alignment: Alignment.center,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(proportionateScreenWidth(16)),
            child: Row(
              children: [
                Container(
                  width: proportionateScreenWidth(70),
                  height: proportionateScreenWidth(70),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE94560), Color(0xFFFF6B9D)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: proportionateScreenWidth(32),
                  ),
                ),
                SizedBox(width: proportionateScreenWidth(16)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        model.dailyPlaylist?.title ?? 'Loading...',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: proportionateScreenWidth(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: proportionateScreenHeight(4)),
                      Text(
                        '${model.dailyPlaylist?.trackCount ?? 0} tracks',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontSize: proportionateScreenWidth(12),
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.play_circle_filled,
                  color: Color(0xFFE94560),
                  size: proportionateScreenWidth(40),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(CosmicDashboardViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: proportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: proportionateScreenHeight(12)),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.self_improvement,
                label: 'Meditation',
                onTap: () => model.generateMeditationTrack(),
              ),
            ),
            SizedBox(width: proportionateScreenWidth(12)),
            Expanded(
              child: _buildActionButton(
                icon: Icons.bedtime,
                label: 'Sleep',
                onTap: () => model.generateSleepTrack(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassmorphicContainer(
        width: double.infinity,
        height: proportionateScreenHeight(80),
        borderRadius: 15,
        blur: 20,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFFE94560), size: proportionateScreenWidth(32)),
            SizedBox(height: proportionateScreenHeight(8)),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: proportionateScreenWidth(14),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedRaags(CosmicDashboardViewModel model) {
    if (model.recommendedRaags.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Raags',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: proportionateScreenWidth(18),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: proportionateScreenHeight(12)),
        Container(
          height: proportionateScreenHeight(120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.recommendedRaags.length,
            itemBuilder: (context, index) {
              final raag = model.recommendedRaags[index];
              return Padding(
                padding: EdgeInsets.only(right: proportionateScreenWidth(12)),
                child: _buildRaagCard(raag),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRaagCard(Raag raag) {
    return GlassmorphicContainer(
      width: proportionateScreenWidth(160),
      height: proportionateScreenHeight(120),
      borderRadius: 15,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.white.withOpacity(0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.1),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(proportionateScreenWidth(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              raag.name,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: proportionateScreenWidth(14),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              raag.nameHindi,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: proportionateScreenWidth(12),
                color: Color(0xFFE94560),
              ),
            ),
            Text(
              raag.benefits.first,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: proportionateScreenWidth(10),
                color: Colors.white.withOpacity(0.6),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
